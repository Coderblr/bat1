import { exec } from 'child_process';
import { promisify } from 'util';
import path from 'path';
import XLSX from 'xlsx';
import fs from 'fs';

const execPromise = promisify(exec);

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { regionName, cifNumber, productCode, accountSegment, noOfAccounts } = req.body;

  // Validate inputs
  if (!regionName || !cifNumber || !productCode || !accountSegment || !noOfAccounts) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  try {
    // Path to your BAT file
    const batFilePath = path.join(process.cwd(), 'scripts', 'your-script.bat');
    
    // Path where the Excel output will be generated
    const outputPath = path.join(process.cwd(), 'output', 'report.xlsx');

    // Execute the BAT file with parameters
    const command = `"${batFilePath}" "${regionName}" "${cifNumber}" "${productCode}" "${accountSegment}" "${noOfAccounts}"`;
    
    console.log('Executing command:', command);
    
    const { stdout, stderr } = await execPromise(command);
    
    if (stderr) {
      console.error('BAT file stderr:', stderr);
    }
    
    console.log('BAT file stdout:', stdout);

    // Wait a bit for the file to be written
    await new Promise(resolve => setTimeout(resolve, 1000));

    // Check if output file exists
    if (!fs.existsSync(outputPath)) {
      throw new Error('Output file was not generated');
    }

    // Read the Excel file
    const workbook = XLSX.readFile(outputPath);
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    
    // Convert to JSON
    const jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1 });
    
    // Extract headers and rows
    const headers = jsonData[0] || [];
    const rows = jsonData.slice(1);

    // Clean up the output file (optional)
    // fs.unlinkSync(outputPath);

    return res.status(200).json({
      headers,
      rows,
      success: true
    });

  } catch (error) {
    console.error('Error executing BAT file:', error);
    return res.status(500).json({ 
      error: 'Failed to execute BAT file',
      details: error.message 
    });
  }
}

// Increase timeout for long-running operations
export const config = {
  api: {
    responseLimit: false,
    externalResolver: true,
  },
};
