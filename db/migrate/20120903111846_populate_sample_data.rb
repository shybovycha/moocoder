class PopulateSampleData < ActiveRecord::Migration
    def self.up
        c = Compiler.new :title => 'g++', :cmd_line => 'g++ %s -o %s', :ext => 'cpp', :compiled => true
        c.save

        p = Problem.new :title => "The Sum",
        :body => %{ You are given with two numbers, <strong>a</strong> and <strong>b</strong>
            (both are read from <strong>stdin</strong>; the only delimiter is space symbol).
            You need to print the sum of those two to the <strong>stdout</strong>.
        },
        :time_limit => 1,
        :examples => %{
            <strong>Input</strong><br /><br />
            1 18
            <br /><br />
            <strong>Output</strong><br /><br />
            19
        }

        p.save

        [
            { :input => "0 0", :output => "0"},
            { :input => "1 0", :output => "1"},
            { :input => "180 -8", :output => "172"},
            { :input => "65535 1", :output => "65536"},
            { :input => "-18 1", :output => "-17"},
        ].each do |test|
            t = TestCase.new  :given => test[:input], :expected => test[:output]
            t.save

            p.test_cases << t
            p.save
        end
    end

    def self.down
    end
end
