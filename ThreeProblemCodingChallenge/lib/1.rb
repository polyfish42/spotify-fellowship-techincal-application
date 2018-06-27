def sort_by_strings(str, order_str)
    order = order_str.chars.each.with_index.reduce({}) do |order, (char, i)|
        order[char] = i
        order
    end

    str.chars.sort_by {|char| order[char]}.join("")
end