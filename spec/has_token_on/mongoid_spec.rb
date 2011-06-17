require File.expand_path('../spec_helper', File.dirname(__FILE__))

connection = Mongo::Connection.new
Mongoid.database = connection.db("has_token_on_test")

describe HasTokenOn::Mongoid do
  before :all do
    class Post
      include Mongoid::Document
      field :slug
      has_token_on :slug, :unique => true
    end
  end

  before :each do
    Post.destroy_all
  end

  subject { Post.new }

  it "should generate unique token if requested" do
    somepost = Post.new
    somepost.stubs(:build_token).returns('hi')
    somepost.save
    subject.expects(:build_token).times(3).returns('hi').then.returns('unique')
    Post.expects(:exists?).twice # on first time we'll find unique
    subject.save
  end

end
