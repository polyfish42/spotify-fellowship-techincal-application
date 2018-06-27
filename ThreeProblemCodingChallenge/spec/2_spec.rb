require 'rspec'
require '2'

describe "#lexer" do
    it "lexes code into correct format" do
        expect(lexer("4[ab]")).to eq(["4","[","ab","]"])
        expect(lexer("a4[b3[cde]]")).to eq(["a","4","[","b","3","[","cde","]","]"])
    end
end

describe "#repeat" do
    it "multiplies string n times" do
        expect(repeat(4, "ab")).to eq("abababab")
    end
end

describe "#decode" do
    it "turns tokens into decoded string" do
        expect(decode(["a","4","[","b","3","[","cde","]","]"])).to eq("abcdecdecdebcdecdecdebcdecdecdebcdecdecde")
    end
end

describe "#decode_string" do
    it "repeats characters in brackets by the number preceding them" do
        expect(decode_string("4[ab]")).to eq("abababab")
        expect(decode_string("2[b3[a]]")).to eq("baaabaaa")
    end

    it "returns strings that aren't encoded" do
        expect(decode_string("abcd")).to eq("abcd")
    end
end