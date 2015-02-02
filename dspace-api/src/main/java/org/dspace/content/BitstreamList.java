/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.content;

import java.lang.StringBuilder;
import org.apache.log4j.Logger;
import org.dspace.core.Context;
import org.dspace.storage.rdbms.DatabaseManager;
import org.dspace.storage.rdbms.TableRow;
import org.dspace.storage.rdbms.TableRowIterator;

/**
 * This is a class is to get the first bitstream of every item in the array, null is given if not found
 * See the constructor for more detailed info
 *
 * @author PastLeo 2015/2/2
 *
 */
public class BitstreamList
{
	/** Logger */
    private static Logger log = Logger.getLogger(BitstreamList.class);

    /** DSpace context */
	private Context context;

	/** bitstream list */
	private Bitstream[] bit_list;

	/** bitstream list cursor */
	private int cursor;

	/** bitstream list length */
	public final int length;

	public BitstreamList(){
		this.length = 0;
		this.bit_list = new Bitstream[length];
		this.cursor = 0;
	}

	/* Get the first bitstream of every item in the array, null is given if not found
	*  index | parameter item | returned bitstream
	*  ------+----------------+---------------------
	*  0     | item_a_has_bs  | first_bs_of_item_a
	*  1     | item_b_no_bs   | null
	*  2     | item_c_has_bs  | first_bs_of_item_c
	* ...
	*/
	public BitstreamList(int[] item_ids,String bundle_name,Context context){
		this.length = item_ids.length;
        this.bit_list = new Bitstream[length];
		this.context = context;
		this.cursor = 0;

		TableRowIterator tri = null;
        StringBuilder debugMsg = new StringBuilder();
        try{
            /* Build a query like this:
            SELECT DISTINCT ON (a.item_id) e.*
            FROM (VALUES (63026),(62851),(82244),(66952),(62944),(83384)) AS a (item_id)
            LEFT JOIN item2bundle AS b ON a.item_id = b.item_id
            LEFT JOIN bundle AS c ON b.bundle_id = c.bundle_id AND c.name = 'ORIGINAL'
            LEFT JOIN bundle2bitstream AS d ON c.bundle_id = d.bundle_id
            LEFT JOIN bitstream AS e ON (c.primary_bitstream_id IS NULL AND d.bitstream_id = e.bitstream_id) OR c.primary_bitstream_id = e.bitstream_id;
            */

            StringBuilder query = new StringBuilder();
            int lastItemIndex = length - 1;
            query.append("SELECT DISTINCT ON (a.item_id) e.* FROM (VALUES ");
            for (int i = 0 ; i < lastItemIndex ; i++) {
                query.append("(");
                query.append(item_ids[i]);
                query.append("),");
            }
            query.append("(");
            query.append(item_ids[lastItemIndex]);
            query.append(")) AS a (item_id) LEFT JOIN item2bundle AS b ON a.item_id = b.item_id LEFT JOIN bundle AS c ON b.bundle_id = c.bundle_id AND c.name = '");
            query.append(bundle_name);
            query.append("' LEFT JOIN bundle2bitstream AS d ON c.bundle_id = d.bundle_id LEFT JOIN bitstream AS e ON (c.primary_bitstream_id IS NULL AND d.bitstream_id = e.bitstream_id) OR c.primary_bitstream_id = e.bitstream_id;");
            String query_str = query.toString();

            debugMsg.append("Using '");
            debugMsg.append(query_str);
            debugMsg.append("' to for items to BitstreamList.\n");

            tri = DatabaseManager.query(context,query.toString());

            if(!tri.hasNext())
                log.warn("There is an empty response from db when query items to BitstreamList");

            debugMsg.append("bitstream: ");
            TableRow r;
            Bitstream fromCache;
            int bitstream_id;
            for (int i = 0 ; i <= lastItemIndex && tri.hasNext() ; i++) {
                try{
                    r = tri.next();
                    bitstream_id = r.getIntColumn("bitstream_id");

                    debugMsg.append("[");
                    debugMsg.append(bitstream_id);
                    debugMsg.append("]: ");

                    if(bitstream_id == -1)
                        continue;
                    // First check the cache
                    fromCache = (Bitstream) context.fromCache(
                            Bitstream.class, r.getIntColumn("bitstream_id"));
                    if (fromCache != null){
                        bit_list[i] = fromCache;
                        fromCache = null;
                    }
                    else{
                        r.setTable("bitstream");
                        bit_list[i] = new Bitstream(context, r);
                    }
                    debugMsg.append(bit_list[i].getName() + ", ");
                }catch(Exception e){
                    log.error("Error on item to bitstreamList iteration: " + e.getMessage());
                }
            }
            log.debug(debugMsg.toString());
        }catch(Exception e){
            log.error(debugMsg.toString());
            log.error("Error on item to bitstreamList: " + e.getMessage());
        }finally{
            // close the TableRowIterator to free up resources
            if (tri != null)
                tri.close();
        }
    }

	/**
	 * Get the next Bitstream
	 *
	 */
	public Bitstream getNextBS()
	{
        if(cursor == length)
			return null;
		return bit_list[cursor++];
    }

	/**
	* Get current cursor
	*
	*/
	public int getCursor(){
		return cursor;
	}
}
