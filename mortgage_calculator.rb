#########################################################
# James McCammon
# 28 March 2017
# Mortgage Loan Calculator (Course 101, Lesson 2)
# Version 1.0
#
# This is a mortgage calculator. It calculates the monthly
# mortgage payment, m, using the simple formula below given
# the following three pieces of information:
# p = loan amount
# j = monthly interest rate
# n = loan duration in months
# m = p * (j / (1 - (1 + j)**(-n)))
##########################################################

require 'yaml'
MESSAGES = YAML.load_file('mortgage_calc_messages.yml')

def messages(message)
  MESSAGES[message]
end

def prompt(message)
  puts("=> #{messages(message)}")
end

def valid_number?(num)
  Float(num) rescue false
end

def read_amount(loan_amount)
  loan_amount.gsub(/\D/, '')
end

def convert_amount(loan_amount)
  loan_amount.to_f
end

def read_rate(rate)
  rate.scan(/\d+|\./).join('')
end

def convert_rate(rate)
  (rate.to_f / 100) / 12
end

def read_duration(loan_duration)
  loan_duration.gsub(/\D/, '')
end

def convert_duration(loan_duration)
  loan_duration.to_f * 12
end

def calculate_payment(loan_amount, monthly_rate, loan_duration)
  numerator = loan_amount * monthly_rate
  denominator = (1 - (1 + monthly_rate)**-loan_duration)
  (numerator / denominator).round(2)
end

def format_payment(unformated_payment)
  number_part, decimal_part = unformated_payment.to_s.split('.')
  number_part_with_comma = number_part.reverse.scan(/\d{1,3}/).join(',').reverse
  '$' + number_part_with_comma + '.' + decimal_part
end

prompt('welcome')

loop do
  loan_amount = ''
  loop do
    prompt('loan_amount_input')
    loan_amount = read_amount(gets.chomp)
    if valid_number?(loan_amount)
      loan_amount = convert_amount(loan_amount)
      break
    else
      prompt('loan_amount_error')
    end
  end

  monthly_rate = ''
  loop do
    prompt('loan_rate_input')
    monthly_rate = read_rate(gets.chomp)
    if valid_number?(monthly_rate)
      monthly_rate = convert_rate(monthly_rate)
      break
    else
      prompt('loan_rate_error')
    end
  end

  loan_duration = ''
  loop do
    prompt('loan_duration_input')
    loan_duration = read_duration(gets.chomp)
    if valid_number?(loan_duration)
      loan_duration = convert_duration(loan_duration)
      break
    else
      prompt('loan_duration_error')
    end
  end

  monthly_payment = calculate_payment(loan_amount, monthly_rate, loan_duration)
  puts("Your monthly payment is #{format_payment(monthly_payment)}.")

  prompt('calculate_again?')
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt('goodbye')
