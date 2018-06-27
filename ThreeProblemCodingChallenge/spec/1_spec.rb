require 'rspec'
require '1'

describe "#sort_by_string" do
    it "sorts the first string input by the second string input" do
        expect(sort_by_strings("weather", "therapyw")).to eq("theeraw")
        expect(sort_by_strings("good", "odg")).to eq("oodg")
    end

    it "handles empty order string" do
        expect(sort_by_strings("weather","")).to eq("weather")
    end

    it "handles empty input string" do
        expect(sort_by_strings("", "therapyw")).to eq("")
    end
end