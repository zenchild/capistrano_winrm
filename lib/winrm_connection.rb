require 'winrm'

class WINRM
  attr_reader :server
  alias :xserver :server

  def initialize(user, pass, endpoint = nil, ssl_ca_store = nil)
    @user = user
    @pass = pass
    @endpoint = endpoint
    @ssl_ca_store = ssl_ca_store
    @int_hash = {}
  end

  def [](key)
    @int_hash[key.to_sym]
  end
  
  def []=(key, value)
    @int_hash[key.to_sym] = value
  end

  def setup_connection(server, options)
    @server = server
    @int_hash[:options] = options
    @int_hash[:server] = server
  end

  def open_channel
    yield self
  end

  def exec(cmd)
    http_method = ( server.port.to_s=~/(443|5986)/ ? 'https' : 'http' )
    endpoint = @endpoint ? @endpoint : "#{http_method}://#{server}/wsman"
    WinRM::WinRM.endpoint = endpoint
    WinRM::WinRM.set_auth(@user, @pass)
    WinRM::WinRM.set_ca_trust_path(@ssl_ca_store) unless @ssl_ca_store.nil?
    inst = WinRM::WinRM.instance
    @ios = inst.cmd(cmd)
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
