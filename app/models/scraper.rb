class Scraper < ActiveRecord::Base
  require 'mechanize'

  def login
    agent = Mechanize.new
    page = agent.get('http://votebuilder.com/')
    form = page.form[0]
    form.field_with(:name => 'ctl00$ContentPlaceHolderVANPage$TextBoxUserName').value = 'ofa.rfitz'
    form.field_with(:name => 'ctl00$ContentPlaceHolderVANPage$TextBoxPassword').value = 'wesbentley!'
    form.field_with(:name => 'ctl00$ContentPlaceHolderVANPage$HiddenFieldTheSite').value = 'votebuilder.com'
    form.field_with(:name => 'ctl00$ContentPlaceHolderVANPage$HiddenFieldWebsiteID').value = 'EIDE01P'
    page = agent.submit(form)
    #page = agent.page.link_with(:text => "click").click
    page = agent.page.link_with(:href => 'http://votebuilder.com/Login.aspx?key=3d59b04d-f5d2-4967-8981-3dab031da481')
  end
end
