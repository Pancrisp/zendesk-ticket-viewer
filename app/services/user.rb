class User
  attr_accessor :name

  def self.find(id)
    response = Request.find_user(id)
    User.new(response['user'])
  end

  def initialize(args = {})
    args.each do |key, value|
      attr_name = key.to_s
      send("#{attr_name}=", value) if respond_to?("#{attr_name}=")
    end
  end
end
