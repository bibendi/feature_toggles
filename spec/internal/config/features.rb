# frozen_string_literal: true

feature(:x) { false }

feature(:y) { |a: nil| a == 0 }
