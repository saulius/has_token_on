require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe HasTokenOn::ActiveRecord do
  subject { Post.new }

  with_model :post do
    table do |t|
      t.string "permalink"
    end

    model do
      has_token_on :permalink, {
        :length => 5,
        :unique => true,
        :prepend => "foo",
        :append => "bar",
        :on => [:create]
      }
    end
  end

  it "should generate unique token if requested" do
    somepost = Post.new
    somepost.stubs(:build_token).returns('hi')
    somepost.save
    subject.expects(:build_token).times(3).returns('hi').then.returns('unique')
    Post.expects(:exists?).twice # on first time we'll find unique
    subject.save
  end

end
