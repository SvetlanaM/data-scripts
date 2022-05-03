import pandas as pd

low_memory=False

def convert_date(date):
    return date.dt.date

def check_same(row):
    if row["provider_y"]==row["on_road"]==row["delivery"]:
        return 1
    else:
        return 0

df_providers = pd.read_csv('in/tables/final_status_transform.csv')
df_c = pd.read_csv('in/tables/connect.csv')
df_providers = df_providers.rename(columns={'DELIVERY_ID': 'del_id', 'UPDATED_DATE' : 'updated_date', \
                                           'REAL_DATE_DELIVERY' : "delivery", 'REAL_DATE_PROVIDER' : 'provider', \
                                           'REAL_DATE_ON_ROAD' : "on_road"})
df_providers.drop(["REAL_DATE_WAREHOUSE", "REAL_DATE_WAREHOUSE_OUT", "REAL_DATE_PICKUP", \
                 "REAL_DATE_STORNO", "REAL_DATE_INIT", "REAL_DATE_PAY"], axis=1, inplace=True)
df_providdf_c = df_c[:][df_c["del_id"].notnull()]
df_providers["del_id"] = df_providers["del_id"].astype('str')
df_c["del_id"] = df_c["del_id"].astype('str')
df = pd.merge(df_c, df_providers, how="inner", on="del_id")
df = df[:][df["state_cz"].isin(['Doručeno', 'Storno'])]
df = df[:][df["del_id"].notnull()]
df["provider_y"] = pd.to_datetime(df["provider_y"]).dt.date
df["delivery"] = pd.to_datetime(df["delivery"]).dt.date
df["on_road"] = pd.to_datetime(df["on_road"]).dt.date
df["diff_provider"] = (pd.to_datetime(df["provider_y"]) - pd.to_datetime(df["real_date_provider"])).dt.days+1
df["diff_on_road"] = (pd.to_datetime(df["on_road"]) - pd.to_datetime(df["real_date_on_road"])).dt.days+1
df["diff_delivery"] = (pd.to_datetime(df["delivery"]) - pd.to_datetime(df["real_date_delivery"])).dt.days+1
df = df.drop_duplicates()
df["the_same"] = df.apply(check_same, axis=1)
df_all = df[["real_date_warehouse_out", "real_date_provider", "real_date_on_road", "real_date_delivery",\
    "diff_provider", "diff_on_road", \
   "diff_delivery", "the_same", "order_id", "tracking_id", "del_id", "provider_x", "delivery", "on_road", "provider_y", "real_date_storno", "type", "deliv_type", "shop_id"]]
df_all = df_all.drop_duplicates()
df_all.to_csv('out/tables/delayed_states.csv', mode='wt', encoding='utf-8', index=False)