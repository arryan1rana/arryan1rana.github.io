import { readFileSync, existsSync } from 'node:fs';
const base=new URL('../',import.meta.url);
const read=p=>readFileSync(new URL(p,base),'utf8');
const checks=[
 ['main entry exists',existsSync(new URL('src/main.js',base))],
 ['public query filters completed projects',read('src/main.js').includes(".eq('status','completed')")],
 ['private project details are not included in public query',read('src/main.js').includes("select('id,title,description,category,tags,url,year')")],
 ['Supabase session uses PKCE',read('src/main.js').includes("flowType: 'pkce'")],
 ['database enables row-level security',read('supabase/schema.sql').includes('enable row level security')],
 ['database limits public reads to completed work',read('supabase/schema.sql').includes('using (status = \'completed\')')],
 ['admin policies bind writes to the configured owner UUID',read('supabase/schema.sql').includes("auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid")],
 ['owner name is configured once',read('src/config.js').includes("name: 'Arryan Rana'")],
 ['requested headline is configured',read('src/config.js').includes("role: 'Student Developer · Building in Public'")],
];
for(const [label,ok] of checks) console.log(`${ok?'PASS':'FAIL'} ${label}`);
if(checks.some(([,ok])=>!ok)) process.exitCode=1;
