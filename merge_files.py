import pandas as pd
import glob, os

"""
loading all files
"""
all_files = glob.glob(os.path.join('in/tables', '*.csv'))

"""
reading all files
"""
temp_df = (pd.read_csv(file) for file in all_files)

"""
merging into one dataframe
"""
concat_df = pd.concat(temp_df, ignore_index=True, sort=False)

concat_df.to_csv('out/tables/provider_history_all.csv', mode='wt', encoding='utf-8', index=False)