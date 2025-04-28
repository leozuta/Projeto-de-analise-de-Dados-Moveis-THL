from flask import Flask, request, jsonify
import sqlite3

app = Flask(__name__)

#conexão ao banco de dados
def get_db_connection():
    conn = sqlite3.connect('data_+usage.db')
    conn.row_factory = sqlite3.Row
    return conn

#rota para adicionar uso de dados moveis
@app.route('/api/data-usage', methods=['POST'])
def add_data_usage():
    device_name = request.form['device_name']
    data_used_mb = float(request.form['data_used_mb'])

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('INSERT INTO data_usage (device_name, data_used_mb) VALUES (?, ?)',
                   (device_name, data_used_mb))
    
    conn.commit()
    conn.close()

    return jsonify({'status': 'sucess'}), 200

#rota para visualização dos dados
@app.route('/api/data-usage', methods=['GET'])
def get_data_usage():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM data_usage')
    data = cursor.fetchall()
    conn.close()

    #conversao de dados pata json
    data_list = [dict(row) for row in data]
    return jsonify(data_list)

if __name__ == '__main__':
    app.run(debug=True)

from flask import render_template

@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute = ('Select * FROM data_usage')
    data = cursor.fetchall()
    conn.close()
    return render_template('index.html', data=data)