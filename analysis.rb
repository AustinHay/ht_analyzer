require 'rubygems'
require 'json'
require 'sass'
require 'csv'
require 'clipboard'

# Using JSON
# cleaned_data = CSV.parse(File.read('ht_partner_data.csv', :encoding=>'ISO-8859-1')).to_json

ht_partners = []
i = 0
csv_raw_data = File.read('ht_partner_data.csv', :encoding=>'ISO-8859-1')
	csv_new_data = CSV.parse(csv_raw_data, :headers => true)
	csv_new_data.each do |row|
	ht_partners[i] = row
	i += 1
end
print "Pick your region: \n AMER | EMEAR | APJC \n"
region = gets.chomp
print "Pick your launch phase: \n PILOT | PILOT2 | ROW \n"
phase = gets.chomp

# Declare initial variables
i = 0
tally = [0,0,0,0,0]
total_NO = [0,0,0,0,0]
total_NA = [0,0,0,0,0]

# Change these variables if the headers change in the file
region_col_name = "Region"
phase_col_name = "[ PILOT, PILOT 2, ROW ]"

# Declare metric variables
metric = 0
metrics = ["GAL Introduction to PAM/CPE [ Y / N ] -N/A for PIL",
		  "GAL Introduction to Partner [ Y / N ]",
		  "Partner Trained [ Y / N / NR ]",
		  "1st Deal Walkthru Scheduled w/ CPE [ Y / N / NR ]",
		  "Partner Trans Comms Sent to Partner/CPE [ Y / N ]"]


print "======================================== \n \n \n"
print "[ CALCULTING ... ] \n \n \n"
print "======================================== \n"

# Calculation
for i in 0 ... ht_partners.count
	if ht_partners[i][region_col_name] == region && ht_partners[i][phase_col_name] == phase	
			for metric in 0 ... metrics.count
	 			if ht_partners[i][metrics[metric]] == "Y"
	 			  	tally[metric] += 1
	 			elsif ht_partners[i][metrics[metric]] == "N"
	 				total_NO[metric] +1
	 			elsif ht_partners[i][metrics[metric]] != "Y"
	 				total_NA[metric] += 1
	 			end

	 		end
	end
end

print "[ Totals ] \n \n"

print "Metrics: \n"
metrics.each do |x| 
	print "   #{x}    \n"
end
print "\n \n"
print "Total Y: #{tally} \n"
print "Total N: #{total_NO} \n"
print "Total NA: #{total_NA} \n"

print "======================================== \n"

print "[ Metric Breakdown ] \n \n"

metric = 0
final_data = []
for metric in 0 ... metrics.count
	print metrics[metric]
	print ": "
	final_data << ( tally[metric].to_f/  (tally[metric]+total_NO[metric]) ) * 100
	print ( tally[metric].to_f/  (tally[metric]+total_NO[metric]) ) * 100
	print "% Y \n \n"
end

# Copy data to clipboard
Clipboard.copy(final_data)

print "Data copied to clipboard!\n \n"
print "[ END OF SESSION ]\n \n"
print "======================================== \n"

