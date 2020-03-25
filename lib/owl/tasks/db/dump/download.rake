require 'net/ssh'
require 'net/scp'

namespace :db do
  namespace :dump do

    desc 'Downloads dump from production'
    task download: :environment do
      raise StandardError, 'This task cannot be executed in production environment!' if Rails.env.production?

      parser = TaskOptionParser.new
      options = parser.parse!

      if File.exist?(options[:dump])
        puts "File '#{options[:dump]}' already exists. Use it or remove and run this task again."
        next
      end

      puts "Downloading fresh production database dump..."
      puts "Starting SSH session as #{options[:user]}@#{options[:host]}..."
      Net::SSH.start(options[:host], options[:user]) do |ssh|

        puts "Processing dump file of the remote database #{options[:remote_db]}..."
        ssh.exec!("pg_dump -O -x -Fc -d #{options[:remote_db]} > #{options[:dump]}")

        puts "Downloading #{options[:dump]} from #{options[:host]}..."
        puts "Starting SCP session as #{options[:user]}@#{options[:host]}..."
        Net::SCP.start(options[:host], options[:user]) do |scp|

          puts "Downloading #{options[:dump]}..."
          scp.download!(options[:dump], Rails.root.to_s)
        end

        puts "Removing #{options[:dump]} from #{options[:host]}..."
        ssh.exec!("rm #{options[:dump]}")
      end
    end
  end
end
