# Automated detection of laser cooling schemes for ultracold molecules

Repository for developing the code to automatically detect molecules that can be laser cooled.

## Quick introduction to Neo4j and Cypher and tips for running the graph search

1. Installation of Neo4j Desktop.
Download the [Neo4j Desktop](https://neo4j.com/download/). The only tip I can give at this point is that be careful if installing Neo4j and using it on a cluster. It deals with the database by creating many small files, so depending on how your cluster works, it may be more efficient to use on a local machine.

2. Cypher and APOC library
If you want to just run the search, there is a fair chance that the tutorial presented in Appendix B of our research paper will be enough.But if you want to modify the code, you need basic basics of Cypher. Check out many [tutorials provided by Neo4j](https://neo4j.com/docs/getting-started/appendix/tutorials/tutorials-overview/). After installation, you'll also see that you have already an example project prepared by developers so you can play with it. The graph search also relies on some methods from the [APOC library](https://neo4j.com/docs/apoc/current/) which is trivial to add to the database with Neo4j Desktop (see in a moment).

3. Creating a new database instance.
You need to create a project folder and inside a database instance (DBMS). After setting a name and a password, go to "Plugins" on the right and install APOC in the DBMS.

4. Set optimal memory settings.
Click on three dots next to your DBMS, choose Terminal, run `bin/neo4j-admin memrec`, note optimal dbms.memory.heap.initial_size, dbms.memory.heap.max_size, and dbms.memory.pagecache.size. Then go again to the three dots, choose Settings, and change those three properties to the recommended values. I also recommend setting dbms.security.auth_enabled=false, because I notice sometimes DBMS have password issues (when opening your DBMS, you'll keep getting a message on unsafe DBMS, but ignore and click Continue Anyway). Apply changes.

5. Importing data to the database.
Use `neo4j-admin import` for importing data, the speedup compared to importing from within the database is incredible. You need to do that BEFORE opening your database instance for the first time!
- Prepare your data as explained in the tutorial in Appendix B of our research paper (follow steps 2-4). It's convenient to have headers (described in step 4) in separate csv files named, e.g., as `states_header.csv` and `trans_header.csv`. See this [tutorial](https://neo4j.com/docs/operations-manual/current/tutorial/neo4j-admin-import/) for extra help. I'm assuming now that your data is either (A) one header file for states (`states_header.csv`), one header file for transitions (`trans_header.csv`), one file with states (`states.csv`), and one file with transitions (`trans.csv`) or (B) the transitions are in multiple files but they start with the same string, e.g., with `14N-1H3`.
- Click on three dots next to your DBMS, choose Open folder -> Import. It opens a folder where you need to transfer your files (it's the only folder that the DBMS sees in your computer). Transfer your data there.
- Open Terminal again. If you have (A) a single file for transitions, run `bin/neo4j-admin import --nodes=State="import/states_header.csv,import/states.csv" --relationships=DECAY="import/trans_header.csv,import/trans.csv"`. If you have (B) multiple files for transitions, run instead `bin/neo4j-admin import --nodes=State="import/states_header.csv,import/states.csv" --relationships=DECAY="import/trans_header.csv,import/14N-1H3.*"`.

6. Done, open your database and play! :) rememeber, that if you have you have thousands of billions of relationships, you need to be smart about addressing nodes. Labels help Neo4j a lot and this is taken into account in the "faster" version of the algorithm.

Finally, feel free to contact me!