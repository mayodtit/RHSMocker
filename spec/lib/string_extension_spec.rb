require 'spec_helper'

describe StringExtension do
  describe '#super_titleize' do
    it 'titleizes normal strings' do
      expect('man from the boondocks'.super_titleize).to eq("Man From The Boondocks")
    end

    it 'titleizes strings preserving hyphens' do
      expect('x-men: the last stand'.super_titleize).to eq("X-Men: The Last Stand")
    end

    it 'does not titleize CamelCaseWords' do
      expect('TheManWithoutAPast'.super_titleize).to eq("TheManWithoutAPast")
    end

    it 'titleizes strings with underscore_case' do
      expect('raiders_of_the_lost_ark'.super_titleize).to eq("Raiders of the Lost Ark")
    end

    it 'does not affect roman numerals' do
      expect('test method VII'.super_titleize).to eq('Test Method VII')
    end

    it 'does not affect roman numerals with hyphens' do
      expect('test method-VII'.super_titleize).to eq('Test Method-VII')
    end

    it 'does not affect wEiRD CapItALiZatIOn' do
      expect('wEiRD CapItALiZatIOn'.super_titleize).to eq('wEiRD CapItALiZatIOn')
    end

    context 'with Allergy use-cases' do
      it 'handles hyphens' do
        expect('Non-cardioselective beta-blocker'.super_titleize).to eq('Non-Cardioselective Beta-Blocker')
      end

      it 'handles roman numerals' do
        expect('Class III antiarrhythmic'.super_titleize).to eq('Class III Antiarrhythmic')
      end

      it 'handles combination cases' do
        expect('Factor IX by-passing fraction products'.super_titleize).to eq('Factor IX By-Passing Fraction Products')
      end

      it 'handles parenthesis' do
        expect('Intravenous nutrition (amino acids)'.super_titleize).to eq('Intravenous Nutrition (Amino Acids)')
      end

      it 'handles slashes' do
        expect('Measles/mumps/rubella vaccine'.super_titleize).to eq('Measles/Mumps/Rubella Vaccine')
      end

      it 'handles plus signs' do
        expect('Ampicillin + flucloxacillin'.super_titleize).to eq('Ampicillin + Flucloxacillin')
      end

      it 'handles acronyms' do
        expect('5-HT3-receptor antagonist'.super_titleize).to eq('5-HT3-Receptor Antagonist')
      end

      it 'handles single hyphens' do
        expect('CCF - Congestive cardiac failure'.super_titleize).to eq('CCF - Congestive Cardiac Failure')
      end

      it 'handles single slashes' do
        expect('CCF / Congestive cardiac failure'.super_titleize).to eq('CCF / Congestive Cardiac Failure')
      end

      it 'handles the most complex case I could find' do
        expect('3-Hydroxy-3-methylglutaryl-coenzyme A (HMG CoA) reductase inhibitor'.super_titleize).to eq('3-Hydroxy-3-Methylglutaryl-Coenzyme A (HMG CoA) Reductase Inhibitor')
      end
    end
  end
end
