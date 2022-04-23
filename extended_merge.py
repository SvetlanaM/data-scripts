import pandas as pd
import glob, os

all_files = glob.glob(os.path.join('in/tables', '*.csv'))
temp_df = (pd.read_csv(file) for file in all_files)
concat_df = pd.concat(temp_df, ignore_index=True, sort=False)

df = concat_df.groupby(['delivery_id', 'state']).size().unstack()
df = df.fillna(0)
df = df.reset_index()
df = df.astype(int)

final = pd.merge(concat_df, df, on='delivery_id', how='inner')

states = ['delayed', 'delayed_on_road', 'delayed_provider', 'delayed_pay', 'delayed_warehouse', 'delayed_warehouse_out', 'delayed_pickup', 'delivered', 'delivered_pickup', 'storno', 'storno_yesterday']

for state in states:
    if state not in final:
        final[state] = 0
        
final = final.drop(["state", "planned_date"], 1)
final = final.drop_duplicates()

df = final[["delivery_id", "status_date", "status_id", "updated_date", "delayed_pay", "delayed_warehouse", "delayed_warehouse_out", "delayed_provider", "delayed_on_road", "delayed", "delayed_pickup", "delivered", "delivered_pickup", "storno", "storno_yesterday"]]

df = df.iloc[:, ::-1]
try:
    df["last_state"] = df.loc[:, ~df.columns.isin(['delivery_id', 'status_date', 'status_id', 'updated_date'])].idxmax(axis=1)
except:
      df["last_state"] = None
    
df.to_csv('out/tables/fact_provider.csv', mode='wt', encoding='utf-8', index=False)
