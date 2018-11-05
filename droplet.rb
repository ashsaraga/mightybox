require 'droplet_kit'
require 'net/http'
require 'uri'
require 'json'
require 'net/ssh'
require 'io/console'

token = ENV['MIGHTYBOX_TOKEN_DO']
sshID = ENV['MIGHTYBOX_SSH_DO']
imageID = ENV['MIGHTYBOX_IMAGE_DO']
region = 'nyc1'
image_id = '#{ imageID }'
droplet_size = 's-1vcpu-2gb'
droplet_tags = ['wordpress', 'mightybox']
ssh_keys = ['#{ sshID }']

puts "Enter site URL:"
sitename = gets.chomp
sitename.gsub!(/\s/,'-')

uri = URI.parse("https://api.digitalocean.com/v2/droplets")
request = Net::HTTP::Post.new(uri)
request.content_type = "application/json"
request["Authorization"] = "Bearer #{ token }"
request.body = JSON.dump({
  "name" => sitename,
  "region" => region,
  "size" => droplet_size,
  "image" => image_id,
  "ssh_keys" => ssh_keys,
  "backups" => true,
  "tags" => droplet_tags
})

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

data = JSON.parse(response.body)

droplet_id = data["droplet"]["id"]
action_id = data["links"]["actions"][0]["id"]

puts "Droplet ID: #{ droplet_id }"
puts "Action ID: #{ action_id }"

action_uri = URI.parse("https://api.digitalocean.com/v2/actions/#{ action_id }")
confirm = Net::HTTP::Get.new(action_uri)
confirm.content_type = "application/json"
confirm["Authorization"] = "Bearer #{ token }"

action_options = {
  use_ssl: action_uri.scheme == "https",
}

action_status = Net::HTTP.start(action_uri.hostname, action_uri.port, action_options) do |http|
  http.request(confirm)
end

deets = JSON.parse(action_status.body)
droplet_status = deets["action"]["status"]

puts "Droplet status: #{ droplet_status }"

while droplet_status != 'completed'
  puts 'Waiting for Droplet...'
  sleep(10)
  action_status = Net::HTTP.start(action_uri.hostname, action_uri.port, req_options) do |http|
    http.request(confirm)
  end
  deets = JSON.parse(action_status.body)
  droplet_status = deets["action"]["status"]
  puts "Droplet status: #{ droplet_status }"
end

puts "Droplet live!"

ripple_uri = URI.parse("https://api.digitalocean.com/v2/droplets/#{ droplet_id }")
ripple = Net::HTTP::Get.new(ripple_uri)
ripple.content_type = "application/json"
ripple["Authorization"] = "Bearer #{ token }"

ripple_options = {
  use_ssl: ripple_uri.scheme == "https",
}

splash = Net::HTTP.start(ripple_uri.hostname, ripple_uri.port, ripple_options) do |http|
  http.request(ripple)
end

current = JSON.parse(splash.body)
wave = current["droplet"]["networks"]["v4"][0]["ip_address"]

puts "#{ sitename } IP address: #{ wave }"
puts ""

puts "GitHub Repo SHH Link:"
sshClone = gets.chomp
puts ""

puts "User:"
user = gets.chomp
puts ""

puts "Database password for 'wordpress_master'"
dbPass = STDIN.noecho(&:gets).chomp
puts ""

puts "Waiting for server..."
sleep(5)

Net::SSH.start(wave, user) do |ssh|
  setup = ssh.exec!("cd /var/www/setup && sudo bash setup.sh #{ sshClone } #{ wave } #{ dbPass }")
  puts setup
end