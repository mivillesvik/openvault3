class OaiController < ApplicationController
  Record = Struct.new(:id, :date, :pbcore)
  ROWS = 2

  def index
    @verb = params[:verb]
    fail("Unsupported verb: #{@verb}") unless @verb == 'ListRecords'

    @metadata_prefix = params[:metadataPrefix] || 'pbcore'
    fail('Unsupported metadataPrefix') unless @metadata_prefix == 'pbcore'

    resumption_token = params[:resumptionToken] || '0'
    fail("Unsupported resumptionToken: #{resumption_token}") unless resumption_token =~ /^\d*$/
    offset = resumption_token.to_i

    @response_date = Time.now.strftime('%FT%T')

    @records =
      RSolr.connect(url: 'http://localhost:8983/solr/')
      .get('select', params: {
             'q' => '*:*',
             'fl' => 'id,timestamp,xml',
             'rows' => ROWS,
             'offset' => offset
           })['response']['docs'].map do |d|
        Record.new(
          d['id'],
          d['timestamp'],
          d['xml'].gsub('<?xml version="1.0" encoding="UTF-8"?>', '').strip)
      end

    @next_resumption_token = # Not ideal: they'll need to go past the end.
      if @records.empty?
        nil
      else
        offset + ROWS
      end

    respond_to do |format|
      format.xml do
        render
      end
    end
  end
end
