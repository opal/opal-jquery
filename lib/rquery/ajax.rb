
class Ajax

  attr_reader :url, :options

  def initialize(url, options = {})
    @url = url
    @options = options

    `var opts = {};`
    opt = nil

    `opts.type = #{ opt.to_s.upcase };` if opt = options[:type]

    `opts.username = opt;` if opt = options[:user]
    `opts.password = opt;` if opt = options[:pass]
    `opts.mimeType = opt;` if opt = options[:mime]
    `opts.data = opt;`     if opt = options[:data]

    `var ajax = self.ajax = $.ajax(#{ @url });`

    block = nil
    success &block  if block = options[:success]
    failure &block  if block = options[:failure]
    complete &block if block = options[:complete]
  end

  def success(&blk)
    `var fn = function() { #{ blk.call }; };
    self.ajax.success(fn);`
    self
  end

  def failure(&blk)
    `var fn = function() { #{ blk.call }; };
    self.ajax.error(fn);`
    self
  end

  def complete(&blk)
    `var fn = function() { #{ blk.call }; };
    self.ajax.complete(fn);`
    self
  end

  def self.get(url, options = {})
    options[:type] = 'GET'
    self.new url, options
  end
end

