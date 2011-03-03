require 'winrm'

class WINRM

  attr_reader :server
  alias :xserver :server

  def initialize(server, opts)
    @server = server
    @int_hash = {:options => opts, :server => server}
    @winrm = establish_winrm(opts)
  end

  def [](key)
    @int_hash[key.to_sym]
  end
  
  def []=(key, value)
    @int_hash[key.to_sym] = value
  end

  def open_channel
    yield self
  end

  def exec(cmd)
    @ios = @winrm.cmd(cmd)
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


  private

  # Create a new WinRM instance
  # @param [Hash] opts the option hash that was passed to initialize
  # @return [WinRM] a new WinRM connection for a particular endpoint
  def establish_winrm(opts)
    http_method = ( server.port.to_s=~/(443|5986)/ ? 'https' : 'http' )
    endpoint = "#{http_method}://#{server}/wsman"
    if opts[:winrm_krb5_realm]
      inst = WinRM::WinRMWebService.new(endpoint, :kerberos, :realm => opts[:winrm_krb5_realm])
    else
      unless opts[:winrm_ssl_ca_store]
        inst = WinRM::WinRMWebService.new(endpoint, :plaintext, :user => opts[:winrm_user], :pass => opts[:winrm_password])
      else
        inst = WinRM::WinRMWebService.new(endpoint, :ssl, :user => opts[:winrm_user], :pass => opts[:winrm_password], :ca_trust_path => opts[:winrm_ssl_ca_store])
      end
    end
    inst
  end

end
