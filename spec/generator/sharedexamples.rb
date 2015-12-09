# Encoding: utf-8
require "rspec"

#
module RubyQuickCheck
  # Examples that should hold for all value generators.
  shared_examples "all generators" do
    let(:size) { 10 }
    let(:seed) { 42 }

    context "with different Random number generators" do
      it "generates different values" do
        seeded_rng = Random.new
        first_generated = (1..size).map { subject.generate(seeded_rng) }
        seeded_rng = Random.new
        second_generated = (1..size).map { subject.generate(seeded_rng) }
        expect(second_generated).not_to eq first_generated
      end
    end

    context "with same Random number generators" do
      it "generates the same values" do
        seeded_rng = Random.new(seed)
        first_generated = (1..size).map { subject.generate(seeded_rng) }
        seeded_rng = Random.new(seed)
        second_generated = (1..size).map { subject.generate(seeded_rng) }
        expect(second_generated).to eq first_generated
      end
    end
  end
end
