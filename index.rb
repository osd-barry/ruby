#!/usr/bin/env ruby
require 'io/console'
require 'colorize'
require_relative "./logic/auth.rb"
include Auth


def clearScreen
    system("cls") || system("clear")
    puts '==============================================='
end

def unAuthScreen
    puts 'Please login to proceed'
    puts '1. Login'
    puts '2. Sign up'

    choice = nil
    loop do 
        choice = gets.chomp().to_i

        if choice != 1 and choice != 2
            puts 'Wrong choice. Please select again'
        end

        break if choice == 1 || choice == 2
    end
    if choice == 1
        loginScreen
    else
        signUpScreen
    end 
end

def loginScreen
    account = Hash.new()
    puts 'Enter username'
    account[:username] = gets.chomp()
    puts 'Enter password'
    account[:password] = STDIN.noecho(&:gets).chomp

    # login logic
    begin
        Auth.logIn(account)
    rescue AuthError => e
        clearScreen
        puts e.message.red
        loginScreen
    end
end


def signUpScreen
    newAccount = Hash.new()
    puts 'Enter username'
    newAccount[:username] = gets.chomp()
    puts 'Enter password'
    newAccount[:password] = STDIN.noecho(&:gets).chomp
    puts 'Confirm password'
    newAccount[:confirmPassword] = STDIN.noecho(&:gets).chomp

    # sign up logic
    begin
        Auth.signUp(newAccount, method(:clearScreen))
    rescue AuthError => e
        clearScreen
        puts e.message.red
        signUpScreen
    end
end

clearScreen
unAuthScreen
