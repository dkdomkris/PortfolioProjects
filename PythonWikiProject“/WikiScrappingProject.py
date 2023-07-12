#!/usr/bin/env python
# coding: utf-8

# In[2]:


from bs4 import BeautifulSoup
import requests


# In[3]:


url = 'https://en.m.wikipedia.org/wiki/List_of_European_financial_services_companies_by_revenue'
page = requests.get(url)
soup = BeautifulSoup(page.text,'html')


# In[4]:


soup.find_all('table')


# In[5]:


table = soup.find('table', class_="wikitable sortable")


# In[6]:


world_titles = table.find_all('th')
print(world_titles)


# In[7]:


world_titles_table = [title.text.strip() for title in world_titles]

print(world_titles_table)


# In[8]:


import pandas as pt


# In[9]:


df = pt.DataFrame(columns = world_titles_table)


# In[10]:


column_data = table.find_all('tr')


# In[11]:


for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data] #first empty 
    
    lenght = len(df)
    df.loc[lenght] = individual_row_data


# In[13]:


df


# In[89]:


df.to_excel(r'C:\Users\helld\Documents\Data\fincompanies.xlsx', index = False)


# In[ ]:




