require "xmpp4r/client"

# Example taken from: https://developer.ibm.com/tutorials/x-xmppintro/


def xmpp_ring(homedir, message)


  logger = Logger.new(STDOUT)
  logger.formatter = proc { |severity, datetime, progname, msg| "#{severity}, #{datetime}, #{msg}\n" }

  if File.exists? "#{homedir}/scripts/credentials.rb" then
    require_relative 'credentials'
  else
    logger.warn "No file 'credentials.rb'. Please copy template and fill in the credentials.\n\tNo XMPP notification will be sent."
    return
  end


  include XmppCredentials

  if SRC == "" or DEST == "" or PASSWORD == "" then
    logger.warn "credentials.rb found but content (SRC, DEST, PASSWORD) is missing.\n\tiNo XMPP notification will be sent."
    return
  end
 

  #Connect to the server and authenticate
  jid = Jabber::JID::new("#{SRC}")
  cl = Jabber::Client::new(jid)
  cl.connect
  cl.auth("#{PASSWORD}")
  #Indicate our presence to the server
  cl.send Jabber::Presence::new
  #Send a salutation to a given user that we're ready
  salutation = Jabber::Message::new("#{DEST}", "#{message}" )
  salutation.set_type(:chat).set_id('1')
  cl.send salutation
end

