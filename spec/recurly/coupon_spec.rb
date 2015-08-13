require 'spec_helper'

describe Coupon do
  let(:coupon) { Coupon.find 'bettercallsaul' }

  before do
    stub_api_request :get, 'coupons/bettercallsaul', 'coupons/show-200'
  end

  describe ".find" do
    it "must return a coupon when available" do
      coupon.must_be_instance_of Coupon
      coupon.plan_codes.must_equal ['saul_good']
    end
  end

  describe "#save" do
    it "must not save a new record" do
      proc { coupon.save }.must_raise Error
    end
  end

  describe "#redeem" do
    it "must be redeemable" do
      stub_api_request(
        :put, "coupons/bettercallsaul/redeem", "redemptions/create-201"
      )
      coupon.redeem 'xX_pinkman_Xx'
    end
  end

  describe "#unlimited_redemptions_per_account?" do
    it "should be false unless max_redemptions_per_account is nil" do
      coupon.max_redemptions_per_account = 10
      coupon.unlimited_redemptions_per_account?.must_equal false
    end
    it "should be true of max_redemptions_per_account is nil" do
      coupon.max_redemptions_per_account = nil
      coupon.unlimited_redemptions_per_account?.must_equal true
    end
  end
end
