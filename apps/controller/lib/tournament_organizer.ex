defmodule TournamentOrganizer do
  import Outcome
  import TournamentError
  import GameRunner
  alias TournamentOrganizer, as: TO
  @game_player_size 2 # 2 players per game of chess
  @default_total_timeout 100000 # 100 seconds
  @default_player_timeout 20000 # 20 seconds
  @default_player_names MapSet.new(["Kim","Joe","Ateev","Jill", "Dimaggie", "Cranston", "brobby", "quentalmeer", "fantabulous", "quant", "quaintest", "Bro", "norm", "nina", "marge", "laquesia", "jasmine", "qwkwavina","wine","beer","khat","Boris Johnson", "Cats", "Dogs", "Wu-Tang", "no", "yes", "maybe", "cool", "not co","not cool", "coolio", "cool beans", "co", "George", "George Washington", "George Bush", "George Bush Sr.", "George Bush Jr.", "George W. Bush", "George H. W. Bush", "George Herbert Walker Bush", "George Walker Bush", "George Walker Bush Jr.", "George Walker Bush Sr.", "George Walker Bush II", "George Walker Bush I", "George Walker Bush", "George Herbert Walker Bush", "George Herbert Walker Bush Jr.", "George Herbert Walker Bush Sr.", "George Herbert Walker Bush II", "George Herbert Walker Bush I", "George Herbert Walker Bush", "George Herbert", "Fred", "Lina", "Gotan"])

  def runTournament(amount_players, playType, games_per_matchup) do
    accepted_players = MapSet.new()
    fn_to_pass = case playType do
      :vs -> #Not doing queryUserForPlayerNames() because it seems bad for developing quickly
        &TO.pickRandomName/1
      :online -> &TO.awaitPlayerConnection/1
        # eventually spawn timeout process here
        #Process.sleep(@default_total_timeout)
        # (time limit of 2 minutes for all players to connect to the TO)
      :cpu -> &TO.pickRandomCPUName/1
      _ -> raise ArgumentError, message: "Invalid playType"
    end
    # accepted_players is a list
    accepted_players = acceptPlayers(accepted_players, amount_players, fn_to_pass) |> Enum.map(fn(ms) -> ms |> MapSet.to_list() |> List.first() end)

    # assign players to game pairs, end up with a list of tuples:
    #    [{"player1", "player2"}, {"player3", "player4"}]
    # also if there is an odd amount of players, the last player gets a bye
    # so if there is 1 player, no games are played, that player simply wins
    # if there are 2 players, 1 game is played, the winner of that game wins
    # if there are 3 players, 2 rounds are played, in the 1st, the 1 and 2 players play, then the winner of the game in round 1 plays in round 2 with the third player
    # if there are 4 players, 2 rounds are played, in the 1st, the 1 and 2 play and the 3 and 4 play, then the winners face off in round 2
    # if there are 5 players, 3 rounds are played, in the 1st, the 1 and 2 play and the 3 and 4 play while 5 gets a bye, then in round 2 the 5 and winner of 1 and 2 play, and the winner of 3 and 4 gets a bye, then in the finals the winners face off

    # doRound is a Recursive function. This is our while loop. It is just recursion.
    # Eventually the round will be passed in 1 player and it will not call doRound anymore, and the tournament will end.
    {winner, round_records} = doRounds(accepted_players, playType, [], games_per_matchup)

    # this conception of tournament completion relies on the only possible way to win a tournament is to play and win games.
    # If a player goes into a round, there is no way for a player to lose that round if the other player loses first.

    # it means a tournament timeout window that might return multiple winners is not easy.
    # so we will move on from that, and refactor when it is required for online tournaments.

   # so map of players to their score in the tourney is a desired feature that is not currently supported, just winner of tournament
   # we will want to spawn a process that will in real time store the current scores of the players in the tournament,
   # that process will be queried if a timeout happens, (there's a timer process too? or is that just the main process)
   {winner, round_records}
  end

  def doRounds([], playType, games_per_matchup, _) do
    raise TournamentError, message: "Round attempted on zero players, there is no possible winner"
  end

  # this is our base case, this must return
  def doRounds([one_player] = accepted_players, playType, games_per_matchup, round_records) do
    {one_player, round_records}
  end

  def doRounds(accepted_players, playType, round_records \\ [], games_per_matchup \\ 2) do
    # DO A ROUND
    outcomes = accepted_players
    # split into pairs in order
    |> Enum.chunk_every(@game_player_size) # [[player1, player2], [player3, player4], [player5]]
    # have the game runner run the games
    |> Enum.map(fn([player1, player2] = players) ->
      TournamentOrganizer.runMatchup(players, playType, games_per_matchup)
    end) # [outcome1, outcome2, outcome3]
    # we know the outcomes, now we must sort the outcomes, reordering the list of players so
    # those that had a bye are first, then those that drew, then those that won
    # [...byes, ...draws, ...wins]

    outcomes
    |> Enum.sort_by(fn(outcome) ->
      case outcome.resolution do
        :win -> 3
        :loss -> 3
        :drawn -> 2
        :bye -> 1
      end
    end) # [outcome3, outcome2, outcome1]
    # [%%Outcome{players: [player5], resolution: :bye, reason: nil},
    #   %%Outcome{players: [player3, player4], resolution: :drawn, reason: :stalemate},
    #   %%Outcome{players: [player1, player2], resolution: :win, reason: :checkmate}]
    # Those who lose do not continue
    # then we convert remaining outcomes to players
    |> Enum.map(TO.convertOutcomeToPlayers/1)
    # [player5, [player3, player4], player1]
    # then we flatten the list so all players are in the same list
    |> List.flatten()
    # [player5, player3, player4, player1]
    # then we just try doing another round
    # we could save matchup_history (so a map of each player in the tournament to a list of their opponents)
    #  and could use that when finding next game pairs, but not right now
    |> doRounds(playType, [outcomes | round_records], games_per_matchup)
  end

  defp convertOutcomeToPlayers(outcome) do
    case outcome do
      # purge losers in win or loss
      %Outcome{players: {winner, loser}, resolution: :win, reason: _} -> winner
      %Outcome{players: {loser, winner}, resolution: :loss, reason: _} -> winner
      # carry byes over
      %Outcome{players: {player}, resolution: :bye, reason: _} -> player
      # carry draws over
      %Outcome{players: {player1, player2}, resolution: :drawn, reason: _} -> [player1, player2]
      _ -> raise ArgumentError, message: "Outcome of: #{outcome} was not a win, loss, bye or draw, confusion"
    end
  end

  defp addScores([p1_score, p2_score], :win), do: [p1_score + 1, p2_score]
  defp addScores([p1_score, p2_score], :loss), do: [p1_score, p2_score + 1]
  defp addScores([p1_score, p2_score], :drawn), do: [p1_score + 0.5, p2_score + 0.5]


  # the matchup is between one player and themself, so they get a bye Outcome
  def runMatchup([player] = players, playType, games_per_matchup, _, _) do
    # if there is only one player, they get a bye
    %Outcome{players: players, resolution: :bye, reason: :bye, games: []}
  end

  # haha you could call this module MatchupRunner instead if you're feeling cheeky
  def runMatchup([player1, player2] = players, playType, games_per_matchup, matchup_score \\ [0, 0], matchAcc \\ []) do
    IO.puts("Matchup: #{inspect(players)}, Score: #{inspect(matchup_score)}, Games: #{inspect(matchAcc)}, PlayType: #{inspect(playType)}")
    # determine the color of the first player and run the game with the right players
    {orange, gameOutcome} = length(matchAcc) |> rem(2) |> case do
      0 ->{player1, GameRunner.runGame(players, playType)}
      1 -> {player2, GameRunner.runGame([player2, player1], playType)}
    end
    IO.puts("Game Outcome: #{inspect(gameOutcome)}")
    # pull out the outcome fields
    %Outcome{players: ps, resolution: res, reason: reas} = gameOutcome
    # add scores and check for completion
    [p1_score, p2_score] = new_matchup_score = addScores(matchup_score, res)
    needed_to_resolve_matchup = (games_per_matchup / 2)
    best_score = max(p1_score, p2_score)

    cond do
      # if the best score is greater than or equal to the number of games needed to win the matchup, then someone has won
      best_score >= needed_to_resolve_matchup ->
        match_res = cond do
          p1_score == p2_score -> :drawn
          p1_score > p2_score -> :win
          p1_score < p2_score -> :loss
        end
        %Outcome{players: players, resolution: match_res, score: new_matchup_score, games: Enum.reverse([{orange, res, reas} | matchAcc])}
      best_score < needed_to_resolve_matchup ->
        runMatchup(players, playType, games_per_matchup, new_matchup_score, [{orange, res, reas} | matchAcc])
    end
  end

  def acceptPlayers(ms_players, amount_players, pick_players_fn) do
    for _i <- 1..amount_players do
      acceptPlayer(ms_players, pick_players_fn)
    end
  end

  def acceptPlayer(ms_players, pick_players_fn) do
    # pick a player
    player = pick_players_fn.(ms_players)
    # add the player to the set of players
    MapSet.put(ms_players, player)
  end

  def pickRandomName(players_already_picked \\ MapSet.new()) do
    case MapSet.size(players_already_picked) do
      0 -> @default_player_names |> mapsetrand()
      _ -> MapSet.difference(@default_player_names, players_already_picked) |> mapsetrand()
    end
  end

  def mapsetrand(mapset) do
    mapset |> MapSet.to_list() |> Enum.random()
  end

  def pickRandomCPUName(players_already_picked \\ MapSet.new()) do
    "#{pickRandomName(players_already_picked)}_CPU"
  end

  # FOR ONLINE PLAY

  def awaitPlayerConnection(_ms_players) do
    #don't know how to TCP connect, will fill in with logic
    # to send out a 'looking for players' message and then
    # to await a TCP connection on port wherever from the client

    #Process.sleep(@default_player_timeout)

    # eventually we will spawn a process and run
    # Process.sleep(@default_player_timeout)
    # on that process. We want the individual player to timeout. Wait we don't want that,
    # we want the player to timeout if they don't make a move in their alloted time.
  end





end
