#!/usr/bin/env crystal

require "./moonphase"
require "spec"

def illumfrac(d : Float64) : Float64
  ((1.0 - Math.cos(d)) / 2.0) * 100.0
end

describe "Tests" do
  it "t1" do
    testdata = [
      {-178070400.0, 1.2},
      {361411200.0, 93.6},
      {1704931200.0, 0.4},
      {2898374400.0, 44.2},
    ]
    testdata.each do |input, expected|
      illumfrac(moonphase(input)).round(1).should eq expected
    end
  end
end
