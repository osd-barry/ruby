#!/usr/bin/env ruby
require 'bcrypt'
require "json"
require_relative "../contanst.rb"
include Constant


module Auth
    def getAccounts
        arr = Array.new
        begin
        arr = JSON.parse(File.read("./files/account.json"))
        end
        return arr
    end

    def signUp(newAccount, callBack)
        accounts = getAccounts
        if newAccount[:password] != newAccount[:confirmPassword]
            raise AuthError.new(COMFIRM_PASSWORD_NOT_MATCH[:type])
        elsif accounts.select {|account| account["username"] == newAccount[:username]}.length == 1
            raise AuthError.new(ACCOUNT_EXIST[:type])
        end
        newAccount[:password] = BCrypt::Password.create(newAccount[:password])
        newAccount.delete(:confirmPassword)
        accounts.push(newAccount)
        File.write('./files/account.json', JSON.pretty_generate(accounts))
        callBack.call
        puts 'Sign up success!'
    end

    def logIn(credential)
        account = getAccounts.select {|account| account['username'] == credential[:username]}
        if account.length == 0
            raise AuthError.new(WRONG_CREDENTIAL[:type])
        elsif BCrypt::Password.new(account[0]["password"]) != credential[:password]
            raise AuthError.new(WRONG_CREDENTIAL[:type])
        else
            puts 'Login success!'
        end
    end
end

class AuthError < StandardError
    def initialize(type)
        @type = type
        case type
        when COMFIRM_PASSWORD_NOT_MATCH[:type]
            super(COMFIRM_PASSWORD_NOT_MATCH[:msg])
        when ACCOUNT_EXIST[:type]
            super(ACCOUNT_EXIST[:msg])
        when WRONG_CREDENTIAL[:type]
            super(WRONG_CREDENTIAL[:msg])
        end
    end

    def type
        @type
    end
end