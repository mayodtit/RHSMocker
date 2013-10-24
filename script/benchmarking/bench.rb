require 'curb'
require 'json'

class RHSSiegeBench
  def initialize(api_url, run_time, concurrent)
    @api_base_path = api_url + '/api/v1/'
    @file_name = '/tmp/siege_urls.txt'

    # siege settings
    @run_time = run_time # in seconds
    @concurrent_connections = concurrent

    create_urls_file
  end

  def attack!
    begin
      cmd = "siege -v -t #{@run_time}s -c #{@concurrent_connections} -f #{@file_name}"
      `#{cmd}`
    ensure
      remove_file
    end
  end

  private

  def get_auth_token
    login_url = @api_base_path + 'login'
    login_email = 'tiem+rhs1@getbetter.com'
    login_password = '12345678'
    http = Curl.post(login_url, { email: login_email, password: login_password})
    JSON.parse(http.body_str)['auth_token']
  end

  def create_urls_file
    auth_param = "auth_token=#{get_auth_token}"
    remove_file
    File.open(@file_name, 'w') do |file|
      paths.each do |p|
        auth_prefix = p.include?('?') ? '&' : '?' # most question marks i've typed in a single line [TS]
        full_url = @api_base_path + p + auth_prefix + auth_param
        file.puts(full_url)
      end
      file.puts('login = rhs:let!me!in')
    end
  end

  def remove_file
    File.delete(@file_name) if File.exists?(@file_name)
  end

  def paths
    [
      # searching
      'contents?q=dia',
      'contents?q=f',
      'contents?q=s',
      'contents?q=aa',

      # factors
      'factors/1',
      'factors/2',
      'factors/3',
      'factors/4',

      # misc
      'association_types',
      'diets',
      'ethnic_groups',
    ]
  end
end

if `which siege` == ''
  puts 'siege command line tool required'
  exit
end

api_urls = [
  'http://rhs:let!me!in@bench1.getbetter.com', # EC2
  'http://api-qa.getbetter.com', # heroku
  #'http://localhost:3000'
]

run_time = 5 # in seconds
concurrent_connections = 1

api_urls.each do |url|
  puts "Benchmarking #{url} with #{concurrent_connections} concurrent connections for #{run_time} seconds"
  puts RHSSiegeBench.new(url, run_time, concurrent_connections).attack!
end