require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe HasTokenOn::Base, "instantiation" do
  subject { Post }

  with_model :post do
    table do |t|
      t.string "permalink"
    end

    model do
      has_token_on :permalink, { :length => 3 }
    end
  end

  its('tokens.size') { should == 1 }
  its('tokens') { should include(:permalink) }

  it "should provide access to set tokens" do
    subject.tokens.size.should == 1
  end

  it "should return set tokens" do
    subject.tokens.first.should == [ :permalink, { :length => 3 } ]
  end

  context "when instantiating" do

    it "should allow to set multiple tokens when multiple calls" do
      subject.class_eval do
        has_token_on :tkn
      end

      subject.tokens.keys.should include(:tkn)
    end

    it "should allow to set multiple tokens with hash syntax" do
      subject.class_eval do
        has_token_on :tkn1 => { :length => 3 }, :tkn2 => { :length => 4 }
      end

      subject.tokens.keys.should include(:tkn1, :tkn2)
    end

    it "should allow to set multiple tokens with array syntax (same configuration for all)" do
      subject.class_eval do
        has_token_on [:tkn3, :tkn4], { :length => 10 }
      end

      subject.tokens.keys.should include(:tkn3, :tkn4)
    end

  end
end

describe HasTokenOn::Base, "callbacks" do
  subject { Post.new }

  with_model :post do
    table do |t|
      t.string "permalink_init"
      t.string "permalink_create"
      t.string "permalink_update"
      t.string "permalink_none"
    end

    model do
      has_token_on :permalink_init, { :length => 3, :on => [:initialize] }
      has_token_on :permalink_create, { :length => 3, :on => [:create] }
      has_token_on :permalink_update, { :length => 3, :on => [:update] }
      has_token_on :permalink_none, { :length => 3 }
    end
  end

  it "should set token on initialize if specified" do
    subject.permalink_init.should_not be_nil
    subject.permalink_create.should be_nil
    subject.permalink_update.should be_nil
  end

  it "should set token on create if specified" do
    subject.save
    subject.permalink_init.should_not be_nil
    subject.permalink_create.should_not be_nil
    subject.permalink_update.should be_nil
  end

  it "should set token on update if specified" do
    subject.save
    subject.update_attribute(:permalink_init, "sup yo")
    subject.permalink_init.should_not be_nil
    subject.permalink_create.should_not be_nil
    subject.permalink_update.should_not be_nil
  end

  it "should generate token before create if configuration doesnt specify :on scope" do
    subject.save
    subject.update_attribute(:permalink_init, "sup yo")
    subject.permalink_none.should_not be_nil
  end
end

describe HasTokenOn::Base do
  subject { Post.new }

  with_model :post do
    table do |t|
      t.string "permalink"
      t.string "test"
      t.string "str"
      t.string "sixteen"
      t.string "proc_seed"
      t.string "range_seed"
      t.string "array_seed"
      t.string "guid_seed"
      t.boolean :check, :default => true
    end

    model do
      has_token_on :permalink => {
        :length => 4,
        :if => lambda {|r| r.check },
        :prepend => "foo",
        :append => "bar",
        :on => [:initialize]
      },
      :test => {
        :length => 4,
        :prepend => "foo",
        :seed => :simplerandom,
        :append => "bar",
        :on => [:initialize]
      },
      :str => {
        :length => 4,
        :seed => ('a'..'z'),
        :if => lambda {|r| !r.check },
        :on => [:initialize]
      },
      :sixteen => {
        :on => [:initialize]
      },
      :proc_seed => {
        :seed => lambda { 2 * 2 },
        :on => [:initialize]
      },
      :range_seed => {
        :seed => ('a'..'z'),
        :on => [:initialize]
      },
      :array_seed => {
        :seed => ['a', 'b', 'c'],
        :on => [:initialize]
      },
      :guid_seed => {
        :seed => :guid,
        :on => [:create]
      }
    end
  end

  context "when setting the token" do

    it "should not be nil if :if executes succcessfully" do
      subject.permalink.should_not be_nil
    end

    it "should be nil if :if executes with false return" do
      subject.str.should be_nil
    end

    it "should be of given length (with prepended and appended parts)" do
      subject.permalink.size.should == 10 # foo****bar
    end

    it "should default length to 16 symbols if not provided" do
      subject.sixteen.length.should == 16
    end

    it "should prepend string if asked" do
      subject.permalink.should =~ /^foo/
    end

    it "should append string if asked" do
      subject.permalink.should =~ /bar$/
    end

    it "should generate GUID using SimpleUUID if it is available" do
      subject.save
      subject.guid_seed.should =~ /[a-z0-9]/
      subject.guid_seed.size.should == 36
    end

    it "should raise an error if SimpleUUID is not available" do
      p = Post.new
      p.stubs(:simple_uuid_present?).returns(false)
      lambda { p.save }.should raise_error
    end

    it "should allow :seed to be described as proc" do
      subject.proc_seed.should == "4"
      subject.proc_seed.size.should == 1
    end

    it "should allow :seed to be described as range" do
      subject.range_seed.should =~ /[a-z]/
      subject.range_seed.size.should == 16
    end

    it "should allow :seed to be described as array" do
      subject.array_seed.should =~ /\A[abc]*\Z/
      subject.array_seed.size.should == 16
    end

  end

end
