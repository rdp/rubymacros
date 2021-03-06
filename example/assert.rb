#this file uses macros! won't parse in normal ruby
macro assert(cond)
    if $Debug
      if RedParse::OpNode===cond and /\A[=!]=\Z/===cond.op
        left,op,right=*cond
        :(fail 'expected '+^left.unparse+"(==#{^left}) to be "+
               ^op+" "+^right.unparse+"(==#{^right})" unless ^cond)    
      else
        :(fail "expected #{:(^^cond)}, but was not true" unless ^cond)
      end
    end
end


#assert_equal... bah, who needs it?

def test_assert
  a=1 
  b=2

  assert a     #ok
  assert a!=b  #ok

  begin
    assert(a==b) #oops, fails. msg="expected a(==1) to be == b(==2)"
  rescue Exception=>e
    assert("expected a(==1) to be == b(==2)"== e.message) #better be ok
  else puts "exception expected but was not seen"
  end

  begin
    assert(nil) #oops, fails. msg="expected nil, but was not true"
  rescue Exception=>e
    assert("expected nil, but was not true"== e.message) #better be ok
    #ok, that message didn't make a lot of sense...
  else puts "exception expected but was not seen"
  end
end
