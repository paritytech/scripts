require 'faker'
require 'fileutils'
require 'json'
require 'securerandom'

require 'minitest/autorun'

def in_tmp_dir
  tmpdir = "/tmp/nbrg-tests-#{SecureRandom.hex[0..10]}"
  FileUtils.mkdir(tmpdir)
  FileUtils.cp('node-bench-regression-guard', tmpdir)
  Dir.chdir(tmpdir) do
    FileUtils.mkdir('references')
    FileUtils.mkdir('comparisons')
    yield
  end
  FileUtils.remove_dir(tmpdir)
end

def generate_name
  Faker::Dessert.flavor.gsub(/[[:space:]]/, '::').downcase
end

def generate_bench_data
  base = rand(100000000...200000000)
  name = "#{generate_name}::#{generate_name}"
  [{name: name, 
    average: (base * rand(0.9..1.1)).to_i, 
    raw_average: (base * rand(0.9..1.1)).to_i}]
end

class NodeBenchRegressionGuardTest < Minitest::Test

  def test_regression_detected
    in_tmp_dir do
      foo = generate_bench_data
      bar = generate_bench_data
      File.write("references/#{foo[0][:name]}", foo.to_json)
      File.write("references/#{bar[0][:name]}","Faker::Quote.famous_last_words\n#{bar.to_json}")
      foo[0][:average] = (foo[0][:average] * rand(2.0..3.0)).to_i
      foo[0][:raw_average] = (foo[0][:average] * rand(0.9..1.1)).to_i
      File.write("comparisons/#{foo[0][:name]}", foo.to_json)
      File.write("comparisons/#{bar[0][:name]}","Faker::Quote.famous_last_words\n#{bar.to_json}")
      puts `./node-bench-regression-guard --reference ./references --compare-with ./comparisons`
    end
    assert_equal($?.exitstatus, 1)
  end

  def test_no_regression_detected
    in_tmp_dir do
      foo = generate_bench_data
      bar = generate_bench_data
      File.write("references/#{foo[0][:name]}", foo.to_json)
      File.write("references/#{bar[0][:name]}","Faker::Quote.famous_last_words\n#{bar.to_json}")
      foo[0][:average] = (foo[0][:average] * rand(1.0..1.2)).to_i
      foo[0][:raw_average] = (foo[0][:average] * rand(0.9..1.1)).to_i
      File.write("comparisons/#{foo[0][:name]}", foo.to_json)
      File.write("comparisons/#{bar[0][:name]}","Faker::Quote.famous_last_words\n#{bar.to_json}")
      puts `./node-bench-regression-guard --reference ./references --compare-with ./comparisons`
    end
    assert_equal($?.exitstatus, 0)
  end

  def test_no_json_in_file
    stdout, stderr = capture_subprocess_io do
      in_tmp_dir do
        foo = generate_bench_data
        bar = generate_bench_data
        File.write("references/#{foo[0][:name]}", foo.to_json)
        File.write("references/#{bar[0][:name]}","Faker::Quote.famous_last_words\n#{bar.to_json}")
        foo[0][:average] = (foo[0][:average] * rand(1.0..1.2)).to_i
        foo[0][:raw_average] = (foo[0][:average] * rand(0.9..1.1)).to_i
        File.write("comparisons/#{foo[0][:name]}", foo.to_json)
        File.write("comparisons/#{bar[0][:name]}","Faker::Quote.famous_last_words\n")
        puts `./node-bench-regression-guard --reference ./references --compare-with ./comparisons`
      end
    end
    assert_match(/contain any JSON line/, stderr)
  end

end
