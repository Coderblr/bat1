import React, { useState } from 'react';
import { AlertCircle, Download, Loader2, FileSpreadsheet } from 'lucide-react';

export default function BatExcelViewer() {
  const [formData, setFormData] = useState({
    regionName: '',
    cifNumber: '',
    productCode: '',
    accountSegment: '',
    noOfAccounts: ''
  });
  const [loading, setLoading] = useState(false);
  const [excelData, setExcelData] = useState(null);
  const [error, setError] = useState('');

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setExcelData(null);

    try {
      // Call your API endpoint that executes the BAT file
      const response = await fetch('/api/execute-bat', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      if (!response.ok) {
        throw new Error('Failed to execute BAT file');
      }

      const data = await response.json();
      setExcelData(data);
    } catch (err) {
      setError(err.message || 'An error occurred while processing your request');
    } finally {
      setLoading(false);
    }
  };

  const handleReset = () => {
    setFormData({
      regionName: '',
      cifNumber: '',
      productCode: '',
      accountSegment: '',
      noOfAccounts: ''
    });
    setExcelData(null);
    setError('');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-6">
      <div className="max-w-6xl mx-auto">
        <div className="bg-white rounded-lg shadow-xl p-8 mb-6">
          <div className="flex items-center gap-3 mb-6">
            <FileSpreadsheet className="w-8 h-8 text-indigo-600" />
            <h1 className="text-3xl font-bold text-gray-800">Database Report Generator</h1>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Region Name
                </label>
                <input
                  type="text"
                  name="regionName"
                  value={formData.regionName}
                  onChange={handleInputChange}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  placeholder="Enter region name"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  CIF Number
                </label>
                <input
                  type="text"
                  name="cifNumber"
                  value={formData.cifNumber}
                  onChange={handleInputChange}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  placeholder="Enter CIF number"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Product Code
                </label>
                <input
                  type="text"
                  name="productCode"
                  value={formData.productCode}
                  onChange={handleInputChange}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  placeholder="Enter product code"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Account Segment
                </label>
                <input
                  type="text"
                  name="accountSegment"
                  value={formData.accountSegment}
                  onChange={handleInputChange}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  placeholder="Enter account segment"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Number of Accounts
                </label>
                <input
                  type="number"
                  name="noOfAccounts"
                  value={formData.noOfAccounts}
                  onChange={handleInputChange}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  placeholder="Enter number of accounts"
                />
              </div>
            </div>

            <div className="flex gap-3 pt-4">
              <button
                type="submit"
                disabled={loading}
                className="flex-1 bg-indigo-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-indigo-700 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed flex items-center justify-center gap-2"
              >
                {loading ? (
                  <>
                    <Loader2 className="w-5 h-5 animate-spin" />
                    Processing...
                  </>
                ) : (
                  'Generate Report'
                )}
              </button>
              <button
                type="button"
                onClick={handleReset}
                className="px-6 py-3 border border-gray-300 rounded-lg font-medium hover:bg-gray-50 transition-colors"
              >
                Reset
              </button>
            </div>
          </form>

          {error && (
            <div className="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg flex items-start gap-3">
              <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
              <p className="text-red-800">{error}</p>
            </div>
          )}
        </div>

        {excelData && (
          <div className="bg-white rounded-lg shadow-xl p-8">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-2xl font-bold text-gray-800">Report Results</h2>
              <button className="flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition-colors">
                <Download className="w-4 h-4" />
                Export Excel
              </button>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full border-collapse">
                <thead>
                  <tr className="bg-gray-100">
                    {excelData.headers?.map((header, idx) => (
                      <th key={idx} className="border border-gray-300 px-4 py-3 text-left font-semibold text-gray-700">
                        {header}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {excelData.rows?.map((row, rowIdx) => (
                    <tr key={rowIdx} className="hover:bg-gray-50">
                      {row.map((cell, cellIdx) => (
                        <td key={cellIdx} className="border border-gray-300 px-4 py-3 text-gray-600">
                          {cell}
                        </td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {excelData.rows?.length === 0 && (
              <p className="text-center text-gray-500 py-8">No data found</p>
            )}
          </div>
        )}
      </div>
    </div>
  );
}







---------------------------------


python

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import subprocess
import pandas as pd
import os
from pathlib import Path
import time

app = FastAPI()

# Enable CORS for Next.js frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # Your Next.js URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ReportRequest(BaseModel):
    regionName: str
    cifNumber: str
    productCode: str
    accountSegment: str
    noOfAccounts: int

class ReportResponse(BaseModel):
    headers: list
    rows: list
    success: bool
    message: str = ""

# Configure paths
BAT_FILE_PATH = Path("scripts/your_script.bat")  # Adjust path
OUTPUT_EXCEL_PATH = Path("output/report.xlsx")  # Adjust path

@app.post("/api/execute-bat", response_model=ReportResponse)
async def execute_bat(request: ReportRequest):
    try:
        # Validate BAT file exists
        if not BAT_FILE_PATH.exists():
            raise HTTPException(
                status_code=500, 
                detail=f"BAT file not found at {BAT_FILE_PATH}"
            )
        
        # Create output directory if it doesn't exist
        OUTPUT_EXCEL_PATH.parent.mkdir(parents=True, exist_ok=True)
        
        # Remove old output file if exists
        if OUTPUT_EXCEL_PATH.exists():
            os.remove(OUTPUT_EXCEL_PATH)
        
        # Prepare command with parameters
        command = [
            str(BAT_FILE_PATH.absolute()),
            request.regionName,
            request.cifNumber,
            request.productCode,
            request.accountSegment,
            str(request.noOfAccounts)
        ]
        
        print(f"Executing command: {' '.join(command)}")
        
        # Execute BAT file
        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            shell=True,
            timeout=300  # 5 minutes timeout
        )
        
        # Check for errors
        if result.returncode != 0:
            print(f"BAT file error: {result.stderr}")
            raise HTTPException(
                status_code=500,
                detail=f"BAT file execution failed: {result.stderr}"
            )
        
        print(f"BAT file output: {result.stdout}")
        
        # Wait for file to be generated
        max_wait = 30  # seconds
        waited = 0
        while not OUTPUT_EXCEL_PATH.exists() and waited < max_wait:
            time.sleep(1)
            waited += 1
        
        if not OUTPUT_EXCEL_PATH.exists():
            raise HTTPException(
                status_code=500,
                detail="Excel file was not generated by the BAT script"
            )
        
        # Read Excel file
        df = pd.read_excel(OUTPUT_EXCEL_PATH)
        
        # Convert to list format
        headers = df.columns.tolist()
        rows = df.values.tolist()
        
        # Convert NaN to None for JSON serialization
        rows = [
            [None if pd.isna(cell) else cell for cell in row] 
            for row in rows
        ]
        
        return ReportResponse(
            headers=headers,
            rows=rows,
            success=True,
            message=f"Successfully processed {len(rows)} records"
        )
        
    except subprocess.TimeoutExpired:
        raise HTTPException(
            status_code=408,
            detail="BAT file execution timed out"
        )
    except Exception as e:
        print(f"Error: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail=f"Error processing request: {str(e)}"
        )

@app.get("/api/health")
async def health_check():
    return {
        "status": "healthy",
        "bat_file_exists": BAT_FILE_PATH.exists(),
        "output_dir_exists": OUTPUT_EXCEL_PATH.parent.exists()
    }

@app.get("/")
async def root():
    return {"message": "FastAPI BAT Executor Service"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
