require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # Loading the 'products.yml' fixture file.
  fixtures :products

  # 1: Testing atributes not empty
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  # 2: Testing price
  test "price must be positive" do
    product = Product.new(:title => 'My book',
                          :description => 'Very interesting',
                          :image_url => 'xyz.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 1
    assert product.valid?
  end
  
  # 3: Testing image names
  def new_product(image_url)
    Product.new(:title => 'My book',
                :description => 'Very interesting',
                :price => 1,
                :image_url => image_url)
  end

  test 'image_url' do
    ok = %w{fred.gif fred.jpg fred.png FRED.GIF FRED.JPG FRED.PNg}  
    bad = %w{fred.doc fred.gif/more fred.gif.more}

    ok.each do |name|
      # The 'assert' method accepts an optional trailing string argument
      # that would be output along with the error if the test fails.
      assert new_product(name).valid?, "#{name} should be valid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} should be invalid"
    end
  end

  # 4: Testing title uniqueness (using fixtures)
  test 'product is not valid without a unique title' do
    product = Product.new(:title => products(:ruby).title,
                :description => 'blabla',
                :price => 1,
                :image_url => 'fred.gif')

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
end



