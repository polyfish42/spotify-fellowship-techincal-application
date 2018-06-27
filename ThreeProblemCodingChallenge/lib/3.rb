def change_possibilities(amount, denominations, memo = {})
    return 1 if amount == 0
    return 0 if amount < 0
    return 0 if denominations.empty?

    with_coin = [[amount - denominations[0], denominations]]
    unless memo[with_coin]
        memo[with_coin] = change_possibilities(amount - denominations[0], denominations, memo)
    end

    without_coins = [[amount, denominations[1..-1]]]
    unless memo[without_coins]
        memo[without_coins] = change_possibilities(amount, denominations[1..-1], memo)
    end

    memo[with_coin] + memo[without_coins]
end