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

    describe "#each" do

      it "yields the same arguments it would also generate" do
        seeded_rng = Random.new(seed)
        values = (1..size).map { subject.generate(seeded_rng) }
        seeded_rng = Random.new(seed)
        expect { |b| subject.each(seeded_rng, size, &b) }.to yield_successive_args(*values)
      end

    end

    describe "#variant" do

      it "generates different values even with the same generator" do
        seeded_rng = Random.new(seed)
        first_generated = (1..size).map { subject.generate(seeded_rng) }
        variant_gen = subject.variant(1)
        seeded_rng = Random.new(seed)
        second_generated = (1..size).map { variant_gen.generate(seeded_rng) }
        expect(second_generated).not_to eq first_generated
      end

    end
  end
end
