import pandas as pd
import datetime

days = ['Monday', 'Tuesday','Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

df = pd.read_csv("in/tables/closetime.csv")
df['PLATNOST_DO'] = pd.to_datetime(df['PLATNOST_DO']).dt.date
dto = datetime.datetime.strptime('2099-12-31', '%Y-%m-%d')
max_date = dto.date()
df = df[:][(df['PLATNOST_DO'] <= max_date) & (df['ACTUAL_INTERVAL'] == 'X')]
new_df = df[["ROUTE", "DAY", "CTIME"]]

for day in days:
    new_df[day] = " "

new_df = new_df.fillna('00:00:00')
a = new_df[:].groupby(['ROUTE', 'DAY'])['CTIME'].max().reset_index()
new_df = pd.merge(new_df, a, on="ROUTE", how='left')
del new_df['DAY_x']
del new_df['CTIME_x']

for (i, row) in new_df.iterrows():
    j = new_df.ROUTE.ne(row['ROUTE']).idxmin()
    new_df.loc[j,[row['DAY_y']]] = row['CTIME_y']

new_df = new_df.drop(['DAY_y', 'CTIME_y'], 1)
new_df = new_df.drop_duplicates()
new_df = new_df.fillna('00:00:00')
new_df = new_df.iloc[::2, :]

new_df = new_df.drop(new_df[new_df["Monday"] == ' '].index)
new_df.to_csv('out/tables/closetime_clean.csv', mode='wt', encoding='utf-8', index=False)