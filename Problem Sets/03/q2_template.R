# Problem Set 3
# Question 2

# Name: Your Name
# Matrikelnummer: Your matriculation number


if (!file.exists("clinton_emails.rda")) {
  clinton_emails <- fromJSON("http://graphics.wsj.com/hillary-clinton-email-documents/api/search.php?subject=&text=&to=&from=&start=&end=&sort=docDate&order=desc&docid=&limit=27159&offset=0")$rows
  save(clinton_emails, file="clinton_emails.rda")
}

load("clinton_emails.rda")

clinton_emails %>% 
  mutate(from=trimws(from),
         to=trimws(to)) %>% 
  filter(from != "") %>% 
  filter(to != "") %>% 
  filter(!grepl(";", from)) %>% 
  filter(!grepl(";", to)) -> clinton_emails

