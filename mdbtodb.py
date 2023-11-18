import os
import sys
import pyodbc
import sqlite3
from datetime import datetime
import tkinter as tk
from tkinter import filedialog
#要求文件路径都在同一个文件夹下 
# 老数据库升级到sqlite数据库,执行即可

print(sys.path[0])
# 定义账套名字
zt = 'HY商贸'
# 定义mdb数据库路径
mdb_path = os.path.join(sys.path[0], 'hy.mdb')
# 定义aqlite db数据库路径
aqlite_path = os.path.join(sys.path[0], 'backup.db')

def query_data(zifuchuan, table_name):
    # 连接到SQLite数据库
    sqlite_conn = sqlite3.connect(aqlite_path)
    sqlite_cursor = sqlite_conn.cursor()
    # 构建查询SQL语句
    sql = f"SELECT id FROM {table_name} where {table_name}='{zifuchuan}'"
    # 执行查询操作
    sqlite_cursor.execute(sql)
    # 获取查询结果
    rows = sqlite_cursor.fetchall()
    # 关闭数据库连接
    sqlite_cursor.close()
    sqlite_conn.close()
    # 返回查询结果
    return [row[0] for row in rows]
def mdb_to_sqlite():    
   # 连接mdb数据库
    mdb_conn_str = (
        r'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};'
        r'DBQ='+mdb_path+';'
    )
    mdb_conn = pyodbc.connect(mdb_conn_str)
    mdb_cursor = mdb_conn.cursor()
    # 使用 sys.path[0] 变量获取当前路径
    current_path = sys.path[0]
    # 连接sqlite数据库
    sqlite_conn = sqlite3.connect(aqlite_path)
    sqlite_cursor = sqlite_conn.cursor()

    # 查询mdb数据库中指定表的数据
    mdb_cursor.execute('SELECT * FROM sjlx')
    rows_jflx = mdb_cursor.fetchall()
    # 创建一个表
    # sqlite_cursor.execute('CREATE TABLE jflx (id INTEGER PRIMARY KEY, jflx TEXT,zhangtao TEXT)')
    for row in rows_jflx:
        values = (row[0], zt)
        sql = 'INSERT INTO jflx (jflx,zhangtao) VALUES (?,?)'
        sqlite_cursor.execute(sql, values)


    # 从jiaofei表中获取数据并插入到zffs表中
    mdb_cursor.execute('SELECT * FROM jiaofei')
    rows_zffs = mdb_cursor.fetchall()
    for row in rows_zffs:
        values = (row[0], zt)
        sql1 = 'INSERT INTO zffs (zffs, zhangtao) VALUES (?,?)'
        sqlite_cursor.execute(sql1, values)
    # # 从chuna表中获取数据并插入到user表中
    mdb_cursor.execute('SELECT * FROM chuna')
    rows_user = mdb_cursor.fetchall()
    for row in rows_user:
        values = (row[0], '202cb962ac59075b964b07152d234b70',zt)
        sql2 = 'INSERT INTO user (user,password,zhangtao) VALUES (?,?,?)'
        sqlite_cursor.execute(sql2, values)
    # 提交事务并关闭连接
    sqlite_conn.commit()
    mdb_cursor.close()
    mdb_conn.close()
    sqlite_cursor.close()
    sqlite_conn.close()
    insert_mingxi()
# mdb_to_sqlite()
# 插入明细函数
def insert_mingxi():
       # 连接mdb数据库
    mdb_conn_str = (
        r'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};'
        r'DBQ='+mdb_path+';'
    )
    mdb_conn = pyodbc.connect(mdb_conn_str)
    mdb_cursor = mdb_conn.cursor()
    # 使用 sys.path[0] 变量获取当前路径
    current_path = sys.path[0]
    # 连接sqlite数据库
    sqlite_conn = sqlite3.connect(aqlite_path)
    sqlite_cursor = sqlite_conn.cursor()
    # 插入收据明细
    mdb_cursor.execute('SELECT * FROM jfjl where 票号>1')
    rows_jfjl = mdb_cursor.fetchall()
    for row in rows_jfjl:
        date_obj = row[8].date() 
        date_str = datetime.strftime(date_obj, "%Y-%m-%d")
        time_str = row[9].strftime("%H:%M:%S") 
        datetime_str = date_str+' '+time_str
        datetime_obj =datetime.strptime(datetime_str, "%Y-%m-%d %H:%M:%S")
        values = (query_data(row[3], 'jflx')[0],query_data(row[7], 'zffs')[0],query_data(row[10], 'user')[0],row[2],row[1],str(row[6]),str(row[11]),datetime_obj,1,row[12])
        sql3= 'INSERT INTO fkmx (jflx_id,zffs_id,user_id,fkzy,fkdw,jine,zf_jine,uptime,zhangtao_id,sjhm) VALUES (?,?,?,?,?,?,?,?,?,?)'
        sqlite_cursor.execute(sql3, values)
    # 提交事务并关闭连接
    sqlite_conn.commit()
    mdb_cursor.close()
    mdb_conn.close()
    sqlite_cursor.close()
    sqlite_conn.close()
if __name__ == '__main__':
    mdb_to_sqlite()
    
