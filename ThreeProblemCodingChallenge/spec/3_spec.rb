require 'rspec'
require '3'

describe "#change_possibilities" do
    it "computes the number of ways to make change with the given demoninations" do
        expect(change_possibilities(4, [1,2,3])).to eq(4)
        expect(change_possibilities(5, [1,2,4])).to eq(4)
        expect(change_possibilities(5, [6,7,8])).to eq(0)
        expect(change_possibilities(5, [])).to eq(0)
    end
end