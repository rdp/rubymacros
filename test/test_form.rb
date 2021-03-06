=begin
    rubymacros - a macro preprocessor for ruby
    Copyright (C) 2008  Caleb Clausen

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end


require "macro"
require 'test/unit'
require 'rubygems'
require 'rubylexer'
require "rubylexer/test/testcases" #from rubylexer
require 'pp'


class FormTest< Test::Unit::TestCase
  EXAMPLES=TestCases::TESTCASES

  EXAMPLES.each_with_index{|x,i|
    next if /__END__/===x
    if / \^[^\s]/===x #and x.size>1000
      while x['^']
        warn "disabling tests of '#{x[/^.*\^.*$/]}'"
        x[/^.*\^.*$/]=''
      end
      next
    end
    define_method "test_form_around_#{x.gsub(/[^ -~]/){|ch| "\\x"+ch[0].to_s(16)}}" do
      check x
    end
  }

  def check(code)
    begin
#      puts code
      begin  as_form=Macro.eval(":(\n"+code+"\n)")
      rescue Exception=>formexc
       0
      end

      begin  
        as_tree=RedParse.new("  \n"+code).parse
        as_tree=RedParse::VarLikeNode["nil", {:@value=>false}] if RedParse::NopNode===as_tree
      rescue Exception=>treeexc
       0
      end

      errs=[formexc,treeexc].compact
      raise errs.first if errs.size==1

#      as_form.delete_extraneous_ivars! if as_form
#      as_tree.delete_extraneous_ivars! if as_tree

      assert_equal as_tree, as_form

      assert_equal as_form, as_form.deep_copy if as_form
    end
  end
end

class FormParameterTest< Test::Unit::TestCase
  DATA=[
    "1", "1.1", "nil", "false", "true",
    ":sym", "[1,2,3]", "{'a'=>4,:b=>6}", "'s'", 
  ]
  DIFFICULT_CHILDREN=[
    "RedParse::ConstantNode[nil,'Object']","(a=[];a<<a)"
  ]

  def form_param_setup datum
      $a=[]
      $b=[]
      Macro.eval(":($a.push(^#{datum}))").eval
      datum=eval datum
  end

  def test_form_params
    DATA.each{|datum|
      datum=form_param_setup datum
      $b.push datum

      assert_equal( $b, $a)
    }
  end

  def test_form_params_dc
    DIFFICULT_CHILDREN.each{|datum|
      datum=form_param_setup datum
      if RedParse::Node===datum
        $b.push datum.eval
      else
        $b.push datum
      end

      assert_equal( $b.inspect, $a.inspect) #byaah, not the best way....
    }
  end
end
