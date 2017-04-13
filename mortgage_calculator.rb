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

def read_number(number)
  number.scan(/\d+|\./).join('')
end

def integer?(num)
  num.to_i.to_s == num
end

def float?(num)
  num.to_f.to_s == num
end

def valid_number?(num)
  integer?(num) || float?(num)
end

def amount_to_float(loan_amount)
  loan_amount.to_f
end

def apr_to_monthly(rate)
  (rate.to_f / 100) / 12
end

def duration_to_month(loan_duration)
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
    loan_amount = read_number(gets.chomp)
    if valid_number?(loan_amount)
      loan_amount = amount_to_float(loan_amount)
      break
    else
      prompt('loan_amount_error')
    end
  end

  monthly_rate = ''
  loop do
    prompt('loan_rate_input')
    monthly_rate = read_number(gets.chomp)
    if valid_number?(monthly_rate)
      if monthly_rate == '0'
        prompt('zero_rate_error')
      else
        monthly_rate = apr_to_monthly(monthly_rate)
        break
      end
    else
      prompt('loan_rate_error')
    end
  end

  loan_duration = ''
  loop do
    prompt('loan_duration_input')
    loan_duration = read_number(gets.chomp)
    if valid_number?(loan_duration)
      if loan_duration == '0'
        prompt('zero_duration_error')
      else
        loan_duration = duration_to_month(loan_duration)
        break
      end
    else
      prompt('loan_duration_error')
    end
  end

  monthly_payment = calculate_payment(loan_amount, monthly_rate, loan_duration)
  puts("Your monthly payment is #{format_payment(monthly_payment)}.")

  answer = ''
  loop do
    prompt('calculate_again?')
    answer = gets.chomp.downcase
    if answer == 'yes' || answer == 'no'
      break
    else
      prompt('trouble_exiting')
    end
  end
  break unless answer == 'yes'
end

prompt('goodbye')
