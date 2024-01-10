import csv

# Input and output file paths
csv_file_path = "lostandfound_data.csv"
txt_file_path = "Text Formate/lostandfound_data.txt"

# Read CSV and write to TXT
with open(csv_file_path, "r") as csv_file, open(txt_file_path, "w") as txt_file:
    csv_reader = csv.reader(csv_file)
    next(csv_reader)  # Skip header row

    pk = set()
    for row in csv_reader:
        (
            LostAndFound_ID,
            Station_Name,
            Claimed_By_Passenger_ID,
            Found_Date,
            Item_Description,
            Claimed,
        ) = row
        # if CateringService_Name in pk:
        #     continue
        # pk.add(CateringService_Name)
        # Address = Address.replace("\n", " ")
        if int(Claimed_By_Passenger_ID) > 5000:
            continue
        formatted_row = f"({LostAndFound_ID},'{Station_Name}',{Claimed_By_Passenger_ID},'{Found_Date}','{Item_Description}','{Claimed}'),\n"
        txt_file.write(formatted_row)
