RSpec.describe RSpec::Variants do
  it "has a version number" do
    expect(RSpec::Variants::VERSION).not_to be nil
  end

  context "data_condition has only one condition to be set" do
    data_condition(:x) do
      [1, 2, 3]
    end

    test_condition do
      it "accurately passes the condition" do
        expect(x).to eq x
      end
    end
  end

  context "data_condition is a single row in tabular syntax" do
    using RSpec::Variants::Tabular

    data_condition(:a, :b, :answer) do
      1 | 2 | 3
    end

    test_condition do
      it "accurately passes the condition" do
        expect(a + b).to eq answer
      end
    end
  end

  context "when the first column is nil, true or false" do
    using RSpec::Variants::Tabular

    data_condition(:a, :result) do
      nil   | nil
      false | false
      true  | true
    end

    test_condition do
      it "accurately passes the condition" do
        expect(a).to be result
      end
    end
  end

  context "data_conditions as tables with different types" do
    context "table separated with pipe" do
      using RSpec::Variants::Tabular

      data_condition(:a, :b, :answer) do
        1         | 2         | 3
        "hello "  | "world"   | "hello world"
        [1, 2, 3] | [4, 5, 6] | [1, 2, 3, 4, 5, 6]
        100000000000000000000 | 100000000000000000000 | 200000000000000000000
      end

      test_condition do
        it "accurately passes the condition" do
          expect(a + b).to eq answer
        end
      end
    end

    describe "table separated with pipe and lambda" do
      using RSpec::Variants::Tabular

      data_condition(:a, :b, :matcher) do
        1         | 2         | -> { eq(3) }
        "hello "  | "world"   | -> { eq("hello world") }
        [1, 2, 3] | [4, 5, 6] | -> { be_a(Array) }
        100000000000000000000 | 100000000000000000000 | -> { eq(200000000000000000000) }
      end

      test_condition do
        it "accurately passes the condition" do
          expect(a + b).to instance_exec(&matcher)
        end
      end
    end
  end

  context 'data_condition has let variables defined by parent example group' do
    describe "parent (define let)" do
      let(:five) { 5 }
      let(:eight) { 8 }

      describe "example with standard data sets" do
        data_condition(:a, :b, :answer) do
          [
            [1 , 2 , 3],
            [five , eight , 13],
          ]
        end

        test_condition do
          it "accurately passes the condition" do
            expect(a + b).to eq answer
          end
        end
      end

      describe "example using tabular syntax" do
        using RSpec::Variants::Tabular

        data_condition(:a, :b, :answer) do
          1         | 2         | 3
          five      | eight     | 13
        end

        test_condition do
          it "accurately passes the condition" do
            expect(a + b).to eq answer
          end
        end
      end

      let(:eq_matcher) { eq(13) }
      describe "example using a matcher" do
        data_condition(:a, :b, :matcher) do
          [
            [1, 2, eq(3) ],
            [five, eight, eq_matcher],
          ]
        end

        test_condition do
          it "accurately passes the condition" do
            expect(a + b).to matcher
          end
        end
      end
    end
  end

  context "the data_condition is after the test_condition" do
    test_condition do
      it "accurately passes the condition" do
        expect(a + b).to eq answer
      end
    end

    test_condition do
      subject { a }
      it { should be_a Numeric }
    end

    data_condition(:a, :b, :answer) do
      [
        [1 , 2 , 3],
        [5 , 8 , 13],
        [0 , 0 , 0]
      ]
    end
  end

  context "the data_condition is between test_conditions" do
    test_condition do
      it "accurately passes the condition" do
        expect(a + b).to eq answer
      end
    end

    data_condition(:a, :b, :answer) do
      [
        [1 , 2 , 3],
        [5 , 8 , 13],
        [0 , 0 , 0]
      ]
    end

    test_condition do
      subject { a }
      it { should be_a Numeric }
    end
  end

  describe "data_condition and test_condition" do
    data_condition(:a, :b, :answer) do
      [
        [1, 2, 3],
        [5, 8, 13],
        [0, 0, 0]
      ]
    end

    test_condition do
      it "accurately passes the condition" do
        expect(a + b).to eq answer
      end
    end

    test_condition do
      it "#{condition[:a]} + #{condition[:b]} == #{condition[:answer]}" do
        expect(a + b).to eq answer
      end
    end
  end

  describe "lambda conditions" do
    data_condition(:a, :b, :answer) do
      [
        [1 , 2 , -> {should == 3}],
        [5 , 8 , -> {should == 13}],
        [0 , 0 , -> {should == 0}]
      ]
    end

    test_condition do
      subject {a + b}
      it "accurately passes the condition" do
        self.instance_exec(&answer)
      end
    end
  end

  describe "hash arguments" do
    data_condition(a: [1, 3], b: [5, 7, 9], c: [2, 4])

    test_condition do
      it "accurately passes the condition" do
        expect(a + b + c).to be_even
      end
    end
  end
end
