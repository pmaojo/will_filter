#--
# Copyright (c) 2010-2016 Michael Berkovich, theiceberk@gmail.com
#
#  __    __  ____  _      _          _____  ____  _     ______    ___  ____
# |  |__|  ||    || |    | |        |     ||    || |   |      |  /  _]|    \
# |  |  |  | |  | | |    | |        |   __| |  | | |   |      | /  [_ |  D  )
# |  |  |  | |  | | |___ | |___     |  |_   |  | | |___|_|  |_||    _]|    /
# |  `  '  | |  | |     ||     |    |   _]  |  | |     | |  |  |   [_ |    \
#  \      /  |  | |     ||     |    |  |    |  | |     | |  |  |     ||  .  \
#   \_/\_/  |____||_____||_____|    |__|   |____||_____| |__|  |_____||__|\_|
#
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

module WillFilter
  module Containers
    class Text < WillFilter::FilterContainer
      def self.operators
        [:is, :is_not, :contains, :does_not_contain, :starts_with, :ends_with]
      end

      def validate
        # always valid, even when it is empty
      end

      def sql_condition
        sanitized_value = value.to_s.downcase
        return [" lower(#{condition.full_key}) = ? ", sanitized_value] if operator == :is
        return [" lower(#{condition.full_key}) <> ? ", sanitized_value] if operator == :is_not
        return [" lower(#{condition.full_key}) like ? ", "%#{sanitized_value}%"] if operator == :contains
        return [" lower(#{condition.full_key}) not like ? ", "%#{sanitized_value}%"] if operator == :does_not_contain
        return [" lower(#{condition.full_key}) like ? ", "#{sanitized_value}%"] if operator == :starts_with
        return [" lower(#{condition.full_key}) like ? ", "%#{sanitized_value}"] if operator == :ends_with
      end
    end
  end
end