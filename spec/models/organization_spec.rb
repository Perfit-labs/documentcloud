require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe "ownership" do
    it "should have an owner"
  end
  
  describe "permissions for user actions" do
    describe "document" do
      context "upload" do
      end
      
      context "editing" do
      end
    end
    
    describe "account" do
      context "invitation" do
      end
      
      context "editing" do
      end
    end
  end
end
