# Copyright (C) 2008  Caleb Clausen
# Distributed under the terms of Ruby's license.
require 'rubygems'
require 'hoe'
 

if $*==["test"]
  #hack to get 'rake test' to stay in one process
  #which keeps netbeans happy
  $:<<"lib"
  $:<<"../redparse/lib" #hack hack hack
  require 'redparse'
  require "test/test_all.rb"
  Test::Unit::AutoRunner.run
  exit
end

require 'lib/macro/version.rb'

   readme=open("README.txt")
   readme.readline("\n== DESCRIPTION:")
   desc=readme.readline("\n==")
 
   hoe=Hoe.new("rubymacros", Macro::VERSION) do |_|
     _.author = "Caleb Clausen"
     _.email = "rubymacros-owner @at@ inforadical .dot. net"
     _.url = ["http://github.com/coatl/rubymacros/", "http://rubyforge.org/projects/rubymacros/"]
     _.extra_deps << ['redparse', '>= 0.8.2']
     _.test_globs=["test/*"]
     _.description=desc
     _.summary=desc[/\A[^.]+\./]
#     _.spec_extras={:bindir=>''}
#     _.rdoc_pattern=/\A(README\.txt|lib\/.*\.rb)\Z/
     _.remote_rdoc_dir="/"
   end


