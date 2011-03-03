require 'winrm'

class WINRM

  attr_reader :server
  alias :xserver :server

  def initialize(user = nil, pass = nil, ssl_ca_store = nil, krb5_realm = nil)
    @user = user
    @pass = pass
    @ssl_ca_store = ssl_ca_store
    @krb5_realm = krb5_realm
    @int_hash = {}
    @server = nil
  end

  def [](key)
    @int_hash[key.to_sym]
  end
  
  def []=(key, value)
    @int_hash[key.to_sym] = value
  end

  def setup_connection(server, options)
    puts "........ #{self.class.name}#winrm_run, #{server}"
    @server = server
    #@int_hash[:options] = options
    #@int_hash[:server] = server
    http_method = ( server.port.to_s=~/(443|5986)/ ? 'https' : 'http' )
    endpoint = "#{http_method}://#{server}/wsman"
    unless(@krb5_realm.nil?)
      @inst = WinRM::WinRMWebService.new(endpoint, :kerberos, :realm => @krb5_realm)
    else
      if @ssl_ca_store.nil?
        @inst = WinRM::WinRMWebService.new(endpoint, :plaintext, :user => @user, :pass => @pass)
      else
        @inst = WinRM::WinRMWebService.new(endpoint, :ssl, :user => @user, :pass => @pass, :ca_trust_path => @ssl_ca_store)
      end
    end
  end

  def open_channel
    yield self
  end

  def exec(cmd)
    @ios = @inst.cmd(cmd)
  end

  def process_data
    @ios[:data].each do |ds|
      key = ds.keys.first
      stream = (key == :stdout) ? :out : :err
      yield self, stream, ds[key]
    end
    self[:status] = @ios[:exitcode]
  end

  def on_data; self; end
  def on_extended_data; self; end
  def on_request(req_type); self; end
  def on_close; self; end

end
